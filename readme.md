# Chris's scoop bucket

[![Tests](https://github.com/chrishenn/scoops/actions/workflows/ci.yml/badge.svg)](https://github.com/chrishenn/scoops/actions/workflows/ci.yml)
[![Excavator](https://github.com/chrishenn/scoops/actions/workflows/excavator.yml/badge.svg)](https://github.com/chrishenn/scoops/actions/workflows/excavator.yml)

## Usage

```pwsh
scoop bucket add chris https://github.com/chrishenn/scoops

# list packages offered by the `chris` bucket
scoop search | grep chris

chris/a4dj        #
chris/amesettings #
chris/appfetch    #
chris/docker      #
chris/epatcher    # <-- customized with my settings
chris/hotkey      #
chris/lnks        #
chris/nvapp       #
chris/nvdriver    # <-- customized to do a minimal install
chris/openshell   # <-- customized with my settings
chris/opgui       #
chris/portable    # <-- installs a private release
chris/powertoys   # <-- customized with my settings
chris/ssh         # <-- needs more testing
chris/steinberg   #
chris/uavolt      #
chris/wt          # <-- customized with my settings
chris/zen         #
chris/zenprof     # <-- installs zen with my settings
```

- Native Instruments Audio 4 DJ Driver (<https://www.native-instruments.com>)
- Ame Settings (<https://github.com/Ameliorated-LLC/ame-settings-cli>)
- Ame AppFetch (<https://github.com/Ameliorated-LLC/appfetch>)
- Explorer Patcher (<https://github.com/valinet/ExplorerPatcher>)
- Windows Actions Lnks (<https://github.com/chrishenn/lnks>)
- Nvidia App (<https://www.nvidia.com/en-us/software/nvidia-app/>)
- Nvidia Driver (<https://www.nvidia.com/en-us/drivers/>)
- Open Shell (<https://github.com/Open-Shell/Open-Shell-Menu>)
- 1Password Desktop (<https://releases.1password.com/windows/stable/>)
- Powertoys (<https://github.com/microsoft/PowerToys>)
- Yamaha Steinberg USB Driver (<https://usa.yamaha.com/support/updates/yamaha_steinberg_usb_driver_for_win.html>)
- Universal Audio Volt Driver (<https://www.uaudio.com/pages/volt>)
- Microsoft Terminal (<https://github.com/microsoft/terminal>)

compute hash for file, to include in scoop manifest

```shell
# PowerShell
Get-FileHash file.zip
# Cmd
certutil -hashfile file.zip SHA256
# Bash
sha256sum file.zip
```

run bucket tests locally (windows only)

```pwsh
# necessary to repeat for each shell in {pwsh, powershell}
powershell
Install-Module Pester -Force -SkipPublisherCheck
install-module -force buildhelpers
cd $HOME\scoop\buckets\chris
.\bin\test.ps1
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

---

## Notes

### Ame Settings, App Fetch (amesettings, appfetch)

Pulled directly from the windows ameliorated project:

- <https://amelabs.net/>
- <https://github.com/Ameliorated-LLC/ame-settings-cli>
- <https://github.com/Ameliorated-LLC/appfetch>

### Explorer Patcher (epatcher)

This epatcher manifest for explorerpatcher is a little rough around the edges. The issue is that the uninstaller cannot
be run silently - it insists on opening win32 dialog windows to confirm the uninstall.

If the user attempts to `scoop uninstall epatcher` from a noninteractive shell (say, a scheduled task or an ssh connection),
the pre-uninstall script _should_ detect that it cannot launch a window from that shell, and error correctly.

If the user attempt the uninstall from an interactive shell but does not proceed with uninstallation via the dialog windows,
_then scoop will assume the uninstallation was successfull, while the installation persists under C:\program files\explorerpatcher._

In this case, the user can just `scoop install chris/epatcher` once more (the explorer patcher install / upgrade is idempotent) and uninstall again, confirming uninstallation
the second time.

### Open Shell (openshell)

I install this with my custom settings applies and install the fluent-ame.skin7 from the ameliorated project (see above).

The other noteworthy change I've made to the `openshell` manifest from the `nonportable` bucket is to add a parameter to
the installer invocation; namely

```pwsh
ADDLOCAL=StartMenu
```

This switch turns off openshell's installation of `classic explorer`, which interferes with my preferred explorer
modifications (explorerpatcher).

Credit

- <https://github.com/ScoopInstaller/Nonportable/blob/master/bucket/open-shell-np.json>

### Nvidia App (nvapp)

Credit

- <https://github.com/emilwojcik93/Install-NvidiaApp>
- <https://github.com/ScoopInstaller/Nonportable/blob/master/bucket/nvidia-display-driver-dch-np.json>
- <https://www.elevenforum.com/t/fix-for-nvidia-taskbar-icon-missing.1853/>

This app will not launch if ALL of its components are not installed. That includes nvtelemetry and
frameviewsdk.

### Nvidia Display Driver (nvdriver)

Credit

- <https://github.com/ScoopInstaller/Nonportable/blob/master/bucket/nvidia-display-driver-dch-np.json>
- <https://github.com/ZenitH-AT/nvidia-update>
- <https://github.com/Aetopia/NVIDIA-Driver-Package-Downloader>
- <https://github.com/lord-carlos/nvidia-update>
- <https://stackoverflow.com/questions/73416586/silently-uninstall-nvidia-display-driver-using-uninstall-string>
  - Source - <https://stackoverflow.com/a>
  - Posted by <https://stackoverflow.com/users/7571258/zett42>

I've copied the upgrade regex directly from the Nonportable nvidia-display-driver-dch-np.json.

My tweaks to the above scripts means that this manifest installs only the nvidia Display.Driver; no HDAudio, no
FrameviewSDK, etc. If want or need driver components other than the Display.Driver, then this manifest won't work for you.

The uninstaller does work, which is a nice upgrade from the nonportable manifest.

---

### Private Sources

The chris/portable, chris/zenprof manifests pull from private repos, and a github token is necessary for download

```bash
scoop config gh_token '<token>'
```
