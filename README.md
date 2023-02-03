# Setting up Dotnet

It is highly recommended to use the dotnet-sdk extension provided by flatpak instead of one installed from your package manager, as that may [break with system updates](https://github.com/flathub/com.jetbrains.Rider/issues/43).
<br>
<br>
To install the dotnet-sdk: 
<br>
`flatpak install flathub org.freedesktop.Sdk.Extension.dotnet6`
<br>
You might need to adjust `dotnet6` to the version you want to install.
<br>
<br>
Then you need to enable the flatpak extension by setting the environment variable:
<br>
`FLATPAK_ENABLE_SDK_EXT` to either `dotnet6` or `*` (to enable all extensions, be sure to check what you enable here).


