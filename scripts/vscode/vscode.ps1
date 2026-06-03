param (
    [switch] $install,
    [switch] $uninstall
)

function install {
    code --install-extension yathink3.carbon-react-color-theme --force
    code --install-extension pkief.material-icon-theme --force
    code --install-extension esbenp.prettier-vscode --force
    code --install-extension be5invis.vscode-custom-css --force
    code --install-extension apility.beautify-blade --force
    code --install-extension isudox.vscode-jetbrains-keybindings --force
    code --install-extension donjayamanne.githistory --force
    code --install-extension RimuruChan.vscode-fix-checksums-next --force

    $cfg = "$persist_dir\data\user-data\User"
    [void](mkdir -force -ea 0 "$cfg")

    $src = "$bucketsdir\chris\scripts\$app"
    cp -force "$src\code.css" $cfg
    cp -force "$src\keybindings.json" $cfg
    cp -force "$src\settings.json" $cfg

    sd 'CODE_CSS' "$cfg\code.css".Replace('\', '/') "$cfg\settings.json"

    # hotkeys fix
    $cfg = "$persist_dir\data\extensions\isudox.vscode-jetbrains-keybindings-*\package.json"
    $cfg = (resolve-path $cfg).path

    if ($psversiontable.psversion.major -le 5) {
        yq -iP 'del(.contributes.keybindings[] | select(.key == """ctrl+`"""))' $cfg -o json
        yq -iP 'del(.contributes.keybindings[] | select(.key == """ctrl+k"""))' $cfg -o json
    } else {
        yq -iP 'del(.contributes.keybindings[] | select(.key == "ctrl+`"))' $cfg -o json
        yq -iP 'del(.contributes.keybindings[] | select(.key == "ctrl+k"))' $cfg -o json
    }
}

function uninstall {
    if (get-process code -ea 0) {
        stop-process -name code -ea 0
        wait-process -name code -ea 0
        start-sleep 0.5
    }
}

function main {
    if ($install) {
        install
    } elseif ($uninstall) {
        uninstall
    }
}
main
