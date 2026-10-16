#!/usr/bin/env bash

# Dir where we'll put shims and add to PATH.
# Usually something like "/home/user/.var/app/com.jetbrains.app/data/shims"
SHIMS_DIR="${XDG_DATA_HOME}/shims"
rm -rf "$SHIMS_DIR"
mkdir -p "${SHIMS_DIR}"

# Create shims for each of the entries in the FLATPAK_SHIMS and FLATPAK_SHIMS_ADD environment variables.
# Multiple entries are delimited with ",", like "docker,kubectl,podman".
IFS=',' read -ra SHIMS <<< "${FLATPAK_SHIMS},${FLATPAK_SHIMS_ADD}"
for shim in "${SHIMS[@]}"; do
	# Trim
	shim="${shim#"${shim%%[![:space:]]*}"}"
	shim="${shim%"${shim##*[![:space:]]}"}"

	# Skip empty entries.
	[[ -z "${shim}" ]] && continue

	SHIM="${SHIMS_DIR}/${shim}"
	echo "Creating shim at $SHIM"
	ln -sfn /app/bin/host-spawn "$SHIM"
done

# Add our shims dir to PATH.
export PATH="${SHIMS_DIR}:${PATH}"

# Register browser shims in the IDE's web browser configuration ("web-browsers.xml"),
# so they show up under Settings > Tools > Web Browsers and Preview.
# Only done when the IDE config dir already exists, as creating it would skip the "import settings" dialog on first start.
CONFIG_DIR_NAME="$(sed -n 's/.*"dataDirectoryName"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' /app/product-info.json 2>/dev/null)"
CONFIG_DIR="${XDG_CONFIG_HOME}/JetBrains/${CONFIG_DIR_NAME}"
if [[ -n "${CONFIG_DIR_NAME}" && -d "${CONFIG_DIR}" ]]; then
	echo "Updating web browsers in ${CONFIG_DIR}/options/web-browsers.xml"
	python3 - "${CONFIG_DIR}/options/web-browsers.xml" "${SHIMS_DIR}" "${SHIMS[@]}" <<'EOF' || echo "Failed to update web browsers"
import os, re, sys, uuid
import xml.etree.ElementTree as ET

path, shims_dir, shims = sys.argv[1], sys.argv[2], [s.strip() for s in sys.argv[3:] if s.strip()]

# Guess the browser family from the shim name, non-browser shims (like "docker") are skipped.
def family(shim):
	name = shim.lower()
	if re.search(r"firefox|librewolf|waterfox|floorp|zen[-_]browser", name):
		return "FIREFOX"
	if re.search(r"chrom|edge|brave|vivaldi|opera", name):
		return "CHROME"
	return None

browsers = {os.path.join(shims_dir, s): (s, family(s)) for s in shims if family(s)}

if os.path.exists(path):
	root = ET.parse(path).getroot()
else:
	root = ET.Element("application")

component = root.find("component[@name='WebBrowsersConfiguration']")
if component is None:
	component = ET.SubElement(root, "component", name="WebBrowsersConfiguration")

# Remove entries for shims that no longer exist, keep existing ones as-is (preserves user changes, like "active").
existing = set()
for browser in component.findall("browser"):
	browser_path = browser.get("path", "")
	if os.path.dirname(browser_path) != shims_dir:
		continue
	if browser_path in browsers:
		existing.add(browser_path)
	else:
		component.remove(browser)

# Add new entries, with a stable id per shim.
for browser_path, (shim, fam) in browsers.items():
	if browser_path in existing:
		continue
	ET.SubElement(component, "browser", {
		"id": str(uuid.uuid5(uuid.NAMESPACE_URL, "flatpak-shim:" + shim)),
		"name": shim,
		"family": fam,
		"path": browser_path,
	})

os.makedirs(os.path.dirname(path), exist_ok=True)
ET.indent(root, space="  ")
ET.ElementTree(root).write(path, encoding="unicode")
EOF
fi

# Start app.
exec /app/bin/rider "$@"
