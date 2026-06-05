# Chris's scoop bucket

[![Tests](https://github.com/chrishenn/scoops/actions/workflows/ci.yml/badge.svg)](https://github.com/chrishenn/scoops/actions/workflows/ci.yml)
[![Excavator](https://github.com/chrishenn/scoops/actions/workflows/excavator.yml/badge.svg)](https://github.com/chrishenn/scoops/actions/workflows/excavator.yml)

My scoop manifests.

Be aware that these manifests are highly customized, and may not behave as you'd expect, or be appropriate for
general use.

These include:
- public manifests customized with my personal settings
- public packages with no scoop manifest in a well-known bucket
- public manifests with nominal bugfixes
- manifests that consume my private releases

These repos are meant to be used together:

- https://github.com/chrishenn/unattend
- https://github.com/chrishenn/chplib
- https://github.com/chrishenn/scoops
- https://github.com/chrishenn/drivers

# usage

NOTE: the hardcoded bucket name 'chris' is required.

```pwsh
scoop bucket add chris https://github.com/chrishenn/scoops
```

```pwsh
# list packages offered by the `chris` bucket
scoop search | grep chris
```

# packages

| name        | program                              | source                                                | notes                                                                                                            |
|-------------|--------------------------------------|-------------------------------------------------------|------------------------------------------------------------------------------------------------------------------|
| a4dj        | Native Instruments Audio 4 DJ Driver | https://www.native-instruments.com                    | Official website is broken; I host their installer on github until it's fixed                                    |
| amdchipset  | AMD chipset driver                   | https://www.amd.com/en/support/downloads/drivers.html |                                                                                                                  |
| amdgfx      | AMD graphics driver                  | https://www.amd.com/en/support/downloads/drivers.html |                                                                                                                  |
| amesettings | AME settings TUI                     | https://github.com/Ameliorated-LLC/ame-settings-cli   |                                                                                                                  |
| appfetch    | AME appfetch TUI                     | https://github.com/Ameliorated-LLC/appfetch           |                                                                                                                  |
| chplib      | Chris' Powershell Library            | https://github.com/chrishenn/chplib                   |                                                                                                                  |
| docker      | Docker                               | https://www.docker.com                                | Installs {containers, microsoft-Hyper-V, cli, engine, compose, buildx, docker service}                           |
| epatcher    | Explorer Patcher                     | https://github.com/valinet/ExplorerPatcher            | Installs my personal settings. Requires interactive shell. [1]                                                   |
| everything  | Everything                           | https://www.voidtools.com                             | Installs my personal settings                                                                                    |
| fcast       | Fcast Sender                         | https://fcast.org                                     | Installs dependencies {yt-dlp, ffmpeg-yt-dlp-nightly, deno}                                                      |
| fluxer      | Fluxer                               | https://fluxer.app                                    |                                                                                                                  |
| fpilot      | File Pilot                           | https://filepilot.tech                                |                                                                                                                  |
| git         | Git                                  | https://gitforwindows.org                             | Uninstaller kills running instances                                                                              |
| hotkey      | Chris' Hotkeys                       | https://github.com/chrishenn/hotkey                   | Installs my personal Autohotkey hotkeys. Registers them to autorun on login.                                     |
| intelbt     | Intel Bluetooth Driver               | https://www.intel.com                                 | For certain Intel bluetooth/wifi nics [2]                                                                        |
| intelgfx    | Intel Graphics Driver                | https://www.intel.com                                 | For 11th-14th gen Intel igpus. Uninstalls: {cplspcon dsaservice dsaupdateservice igccservice, support-assistant} |
| intelhid    | Intel Human Interface Driver         | https://github.com/chrishenn/drivers                  | For recent intel chipsets                                                                                        |
| intelwifi   | Intel Wifi Driver                    | https://www.intel.com                                 | For certain Intel bluetooth/wifi nics [2]                                                                        |
| iriun       | Iriun Webcam                         | https://iriun.com                                     |                                                                                                                  |
| lnks        | Power Actions Links                  | https://github.com/chrishenn/lnks                     | My windows shortcut lnks for power actions {hibernate, recycle bin, restart, shutdown, sleep}                    |
| mpv         | MPV                                  | https://mpv.io                                        | Installs my custom settings                                                                                      |
| nvapp       | Nvidia App                           | https://www.nvidia.com/en-us/software/nvidia-app      | Hides the nvidia tray icon [3]                                                                                   |
| nvgfx       | Nvidia Graphics Driver               | https://www.nvidia.com/en-us/drivers                  | Minimal install (driver only). Scoop uninstall works. Hides the nvidia tray icon. [4]                            |
| openshell   | Open Shell                           | https://github.com/Open-Shell/Open-Shell-Menu         | Installs start menu only. Customized with my personal settings.                                                  |
| opgui       | 1Password Desktop                    | https://releases.1password.com/windows/stable         |                                                                                                                  |
| opgui_np    | 1Password Desktop Nonportable        | https://releases.1password.com/windows/stable         | Integrates with browser extensions                                                                               |
| opguib      | 1Password Desktop Beta               | https://releases.1password.com/windows/beta           |                                                                                                                  |
| opguib_np   | 1Password Desktop Beta Nonportable   | https://releases.1password.com/windows/beta           | Integrates with browser extensions                                                                               |
| pangolin    | Pangolin Client                      | https://github.com/fosrl/windows                      |                                                                                                                  |
| pdanet      | PDANet                               | https://pdanet.co                                     | Requires interactive shell                                                                                       |
| portable    | Chris' Portable Apps                 | https://github.com/chrishenn/portable                 | Installs my private distribution of portable apps                                                                |
| powertoys   | Powertoys                            | https://github.com/microsoft/PowerToys                | Installs my custom settings                                                                                      |
| rtklan      | Realtek Lan Driver                   | https://github.com/chrishenn/realtek                  | Official website is broken; I host their install on github until it's fixed                                      |
| ssh         | SSH                                  | https://github.com/PowerShell/Win32-OpenSSH           | Fixed install location; installs sshd as autostart; configures git to use this ssh instance                      |
| steinberg   | Yamaha Steinberg USB Driver          | https://o.steinberg.net                               |                                                                                                                  |
| termix      | Termix Client GUI                    | https://github.com/Termix-SSH/Termix                  |                                                                                                                  |
| uavolt      | Universal Audio Volt Driver          | https://www.uaudio.com                                | Minimal installer extracted from official blotware                                                               |
| vscode      | Vscode                               | https://github.com/microsoft/vscode                   | Customized with my personal settings                                                                             |
| wt          | Windows Terminal                     | https://github.com/microsoft/terminal                 | Customized with my personal settings                                                                             |
| zen         | Zen Browser                          | https://www.zen-browser.app                           | Fixes a broken program shortcut. Uninstaller kills running instances.                                            |
| zen_np      | Zen Browser Nonportable              | https://www.zen-browser.app                           | Integrates with 1Password Desktop                                                                                |
| zenprof     | Chris' Zen Browser Profile           | https://github.com/chrishenn/zenprof                  | Installs my private distribution of my zen browser profile                                                       |

There are also some experimental driver packages that should be ignored. 

# dev

Compute hash for file, to include in scoop manifest

```shell
# pwsh
Get-FileHash file.zip
# bash
sha256sum file.zip
```

Run bucket tests locally (windows only)
Repeat for each shell in {pwsh, powershell}

```pwsh
Install-Module Pester -Force -SkipPublisherCheck
install-module -force buildhelpers
.\bin\test.ps1
```

Run github workflow tests locally (windows only)

```pwsh
scoop install pester act nodejs 1password-cli
git config --system core.fsmonitor false
git config core.fsmonitor false

act push -s GITHUB_TOKEN=$(op read op://homelab/github/credential) -P windows-latest=-self-hosted
act -j test_pwsh -s GITHUB_TOKEN=$(op read op://homelab/github/credential) -P windows-latest=-self-hosted
act -j test_powershell -s GITHUB_TOKEN=$(op read op://homelab/github/credential) -P windows-latest=-self-hosted
```

Install manifests that download private releases

```pwsh
# use a github pat with read access to the private repo's releases
scoop config gh_token (op read "op://homelab/github/credential")
scoop install chris/portable chris/zenprof
```

Update manifests that download private releases

```pwsh
.\bin\checkver.ps1
# portable: 0.0.2 (scoop version is 0.0.1) autoupdate available

.\bin\checkver.ps1 portable -u
git pull
git add --all
git commit -am "portable: Update to version 0.0.2"
git push
```

---

# footnotes

[1] epatcher (Explorer Patcher) 

This epatcher manifest for explorerpatcher is a little rough around the edges. The issue is that the uninstaller cannot
be run silently - it insists on opening win32 dialog windows to confirm the uninstall.

If the user attempts to `scoop uninstall epatcher` from a noninteractive shell (say, a scheduled task or an ssh connection),
the pre-uninstall script _should_ detect that it cannot launch a window from that shell, and abort the uninstallation with a helpful message.

If the user attempts the uninstall from an interactive shell but does not proceed with uninstallation via the dialog windows,
_then scoop will assume the uninstallation was successfull, while the installation persists under C:\program files\explorerpatcher._

In this case, the user can just `scoop install chris/epatcher` once more (the install is idempotent) and uninstall again, confirming uninstallation the second time (`scoop uninstall epatcher`).

[2] Intel Bluetooth driver for:
- Intel BE213, BE211, BE202, BE201, BE200, AX411, AX211, AX210, AX203, AX201, AX101, 9560, 9462, 9461, 9260
- Intel Killer BE1775(i/s), BE1750(x/w), BE1750(i/s), AX1690, AX1675, AX1650(i/s), 1550

[3] nvapp (Nvidia App)

refs: 

- <https://github.com/emilwojcik93/Install-NvidiaApp>
- <https://github.com/ScoopInstaller/Nonportable/blob/master/bucket/nvidia-display-driver-dch-np.json>
- <https://www.elevenforum.com/t/fix-for-nvidia-taskbar-icon-missing.1853/>

This app will not launch if ALL of its components are not installed. That includes nvtelemetry and frameviewsdk.

I updated the nvapp uninstaller to also uninstall the frameviewSDK. In my setup, the nvapp is the only component that
installs the frameviewSDK and then (rudely) fails to uninstall it.

[4] nvgfx (Nvidia Display Driver)

refs: 

- <https://github.com/ScoopInstaller/Nonportable/blob/master/bucket/nvidia-display-driver-dch-np.json>
- <https://github.com/ZenitH-AT/nvidia-update>
- <https://github.com/Aetopia/NVIDIA-Driver-Package-Downloader>
- <https://github.com/lord-carlos/nvidia-update>
- <https://stackoverflow.com/questions/73416586/silently-uninstall-nvidia-display-driver-using-uninstall-string>
  - Source - <https://stackoverflow.com/a>
  - Posted by <https://stackoverflow.com/users/7571258/zett42>

My tweaks to the above scripts means that this manifest installs only the nvidia Display.Driver; no HDAudio, no
FrameviewSDK, etc. If want or need driver components other than the Display.Driver, then this manifest won't work for you.
