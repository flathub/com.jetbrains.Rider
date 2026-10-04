# Setting up Dotnet

It is highly recommended to use the dotnet-sdk extension provided by flatpak instead of one installed from your package manager, as that may [break with system updates](https://github.com/flathub/com.jetbrains.Rider/issues/43).

To install the dotnet-sdk: 

```bash
flatpak install flathub org.freedesktop.Sdk.Extension.dotnet10
```

You might need to adjust `dotnet10` to the version you want to install.

Then you need to enable the flatpak extension by setting the environment variable:

`FLATPAK_ENABLE_SDK_EXT` to either `dotnet10` or `*` (to enable all extensions, be sure to check what you enable here).

## Local Build

Install flatpak-builder:

```bash
flatpak install --user --assumeyes flathub org.flatpak.Builder
```

Add Flathub as a user-wide repo:

```bash
flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```

Build Rider flatpak (for current architecture, including install):

```bash
./build.sh
```

Build flatpak for specific architecture, without install:

```bash
./build-aarch64.sh
./build-x86_64.sh
```
