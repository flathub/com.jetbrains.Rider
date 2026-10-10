#!/usr/bin/env bash

# Dir where we'll put shims and add to PATH.
# Usually something like "/home/user/.var/app/com.jetbrains.app/data"
SHIMS_DIR="${XDG_DATA_HOME}/bin"
mkdir -p "${SHIMS_DIR}"

# Create shims for each of the entries in the FLATPAK_SHIMS environment variable.
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

# Start app.
exec /app/bin/rider "$@"
