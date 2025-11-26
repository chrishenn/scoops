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

The unattend scripts attempt to install and configure a {working, debloated, de-spyware'd} windows 11 OS for development
with no manual intervention. This scoops repo, then, uses the scoop packaging framework to provide customized software
installs.


## usage

```pwsh
scoop bucket add chris https://github.com/chrishenn/scoops
```

```pwsh
# list packages offered by the `chris` bucket
scoop search | grep chris
```


## references

- Native Instruments Audio 4 DJ Driver (<https://www.native-instruments.com>)
  - their website is broken, so I've hosted their driver installer on github, and it is consumed by this manifest
- AMD chipset driver (<https://www.amd.com/en/support/downloads/drivers.html>)
- AMD graphics driver (<https://www.amd.com/en/support/downloads/drivers.html>)
- Ame Settings (<https://github.com/Ameliorated-LLC/ame-settings-cli>)
- Ame AppFetch (<https://github.com/Ameliorated-LLC/appfetch>)
- Docker (<https://www.docker.com/>)
  - installs pre-requisites for windows containers on windows client {containers, microsoft-Hyper-V}
  - installs scoop docker {cli, engine, compose, buildx}
  - registers the docker service and sets it to autostart
- Explorer Patcher (<https://github.com/valinet/ExplorerPatcher>)
  - customized
- Everything (<https://www.voidtools.com/>)
- File Pilot (<https://filepilot.tech/>)
- Hotkey (<https://github.com/chrishenn/hotkey>)
  - my hotkeys
- Windows Actions Lnks (<https://github.com/chrishenn/lnks>)
  - my windows shortcut lnks for power actions {hibernate, recycle bin, restart, shutdown, sleep}
- Nvidia App (<https://www.nvidia.com/en-us/software/nvidia-app/>)
  - hides the nvidia tray icon
- Nvidia Driver (<https://www.nvidia.com/en-us/drivers/>)
  - fixes missing uninstaller from existing manifest
  - customized to do a minimal install
  - hides the nvidia tray icon
- Open Shell (<https://github.com/Open-Shell/Open-Shell-Menu>)
  - customized
- 1Password Desktop (<https://releases.1password.com/windows/stable/>)
- Portable
  - installs a private release of portable apps
- Powertoys (<https://github.com/microsoft/PowerToys>)
  - customized
- OpenSSH (<https://github.com/PowerShell/Win32-OpenSSH/releases/>)
  - fixed install location to work on my machine (with UAC disabled)
  - installs sshd and sets it to autostart
  - configures git to use this installation of openssh
- Yamaha Steinberg USB Driver (<https://usa.yamaha.com/support/updates/yamaha_steinberg_usb_driver_for_win.html>)
- Universal Audio Volt Driver (<https://www.uaudio.com/pages/volt>)
  - they don't publish a driver installer, so I've extracted this one from some bloatware they do ship
- VSCode (<https://github.com/microsoft/vscode>)
  - customized
- Microsoft Terminal (<https://github.com/microsoft/terminal>)
  - customized
- Zen Browser (<https://zen-browser.app/>)
  - customized


## dev

compute hash for file, to include in scoop manifest

```shell
# pwsh
Get-FileHash file.zip
# bash
sha256sum file.zip
```

run bucket tests locally (windows only)

```pwsh
# necessary to repeat for each shell in {pwsh, powershell}
Install-Module Pester -Force -SkipPublisherCheck
install-module -force buildhelpers
& "$HOME\scoop\buckets\chris\bin\test.ps1"
```

run github workflow tests locally (windows only)

```pwsh
scoop install pester act nodejs 1password-cli
git config --system core.fsmonitor false
git config core.fsmonitor false

act push -s GITHUB_TOKEN=$(op read op://homelab/github/credential) -P windows-latest=-self-hosted
act -j test_pwsh -s GITHUB_TOKEN=$(op read op://homelab/github/credential) -P windows-latest=-self-hosted
act -j test_powershell -s GITHUB_TOKEN=$(op read op://homelab/github/credential) -P windows-latest=-self-hosted
```

install manifests that download private releases

```pwsh
# use a github pat with read access to the private repo's releases
scoop config gh_token (op read "op://homelab/github/credential")
scoop install chris/portable chris/zenprof
```

update manifests that download private releases

```pwsh
.\bin\checkver.ps1
# portable: 0.0.2 (scoop version is 0.0.1) autoupdate available

.\bin\checkver.ps1 portable -u
git pull
git add --all
git commit -am "portable: Update to version 0.0.2"
git push
```


## notes

### Explorer Patcher (epatcher)

This epatcher manifest for explorerpatcher is a little rough around the edges. The issue is that the uninstaller cannot
be run silently - it insists on opening win32 dialog windows to confirm the uninstall.

If the user attempts to `scoop uninstall epatcher` from a noninteractive shell (say, a scheduled task or an ssh connection),
the pre-uninstall script _should_ detect that it cannot launch a window from that shell, and abort the uninstallation with a helpful message.

If the user attempts the uninstall from an interactive shell but does not proceed with uninstallation via the dialog windows,
_then scoop will assume the uninstallation was successfull, while the installation persists under C:\program files\explorerpatcher._

In this case, the user can just `scoop install chris/epatcher` once more (the install is idempotent) and uninstall again, confirming uninstallation the second time (`scoop uninstall epatcher`).

### Open Shell (openshell)

- <https://github.com/Open-Shell/Open-Shell-Menu>
- <https://github.com/ScoopInstaller/Nonportable/blob/master/bucket/open-shell-np.json>

I install the fluent-ame.skin7 from the ameliorated project. I also updated the nonportable manifest by installing with `ADDLOCAL=StartMenu`.

This switch turns off openshell's installation of `classic explorer`, which interferes with my preferred explorer
modifications (explorerpatcher).

### Nvidia App (nvapp)

- <https://github.com/emilwojcik93/Install-NvidiaApp>
- <https://github.com/ScoopInstaller/Nonportable/blob/master/bucket/nvidia-display-driver-dch-np.json>
- <https://www.elevenforum.com/t/fix-for-nvidia-taskbar-icon-missing.1853/>

This app will not launch if ALL of its components are not installed. That includes nvtelemetry and frameviewsdk.

I updated the nvapp uninstaller to also uninstall the frameviewSDK. In my setup, the nvapp is the only component that
installs the frameviewSDK and then (rudely) fails to uninstall it.

### Nvidia Display Driver (nvgfx)

- <https://github.com/ScoopInstaller/Nonportable/blob/master/bucket/nvidia-display-driver-dch-np.json>
- <https://github.com/ZenitH-AT/nvidia-update>
- <https://github.com/Aetopia/NVIDIA-Driver-Package-Downloader>
- <https://github.com/lord-carlos/nvidia-update>
- <https://stackoverflow.com/questions/73416586/silently-uninstall-nvidia-display-driver-using-uninstall-string>
  - Source - <https://stackoverflow.com/a>
  - Posted by <https://stackoverflow.com/users/7571258/zett42>

I've tweaked the checkver regex, initially copied directly from the Nonportable manifest for the same.

My tweaks to the above scripts means that this manifest installs only the nvidia Display.Driver; no HDAudio, no
FrameviewSDK, etc. If want or need driver components other than the Display.Driver, then this manifest won't work for you.

The uninstaller also works, which is a nice upgrade from the nonportable manifest.


## todo

- the steinberg installer runs noninteractive but opens a window
