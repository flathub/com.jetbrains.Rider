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

# NOT RECOMMENDED
This is not really recommended as it will communicate with the .NET install outside the flatpak app and decreases the sandbox effictiveness

## If you want to use an existing dotnet install (Systemwide .NET installed through APT or Microsoft's install script)

Just a guide for those who need to use their dotnet install across the whole system not just Rider also for those using Entity Framework and trying to get the tools working.

First thing to do is to set the path. By default the PATH variable for the shell in any flatpak app is cleared so the app can use it's own, so you'll need to pass in the path variables.

An example of the path variables in Rider's shell

<img width="1276" height="101" alt="image" src="https://github.com/user-attachments/assets/cf31a78b-ec20-4e3f-9475-ab2e1805a3df" />

Flatseal is the easiest way to add this and also saves you editing your .desktop file

<img width="571" height="264" alt="image" src="https://github.com/user-attachments/assets/8521cb7b-3983-4236-bcb1-85ae15cbe3d6" />

### Important: When adding your $PATH variable make sure to add /app/bin:/usr/bin (Tested on debian 12) to it otherwise the app will not run. The other variables that are shown in the shell will be automatically added by Rider.

This way you can pass in any environment variable you want and it is permanent.

# If the app is not launching on first install

Double check that it is not using wayland to run as support for wayland is yet to come as of version 2026.1.0.1

This is what the proper permissions should look like in flatseal

<img width="585" height="454" alt="image" src="https://github.com/user-attachments/assets/b40dff9b-dbb4-4818-901e-bd92aaf27060" />









