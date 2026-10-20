alias f := fix
alias c := check
alias s := sync

sync message="sync":
    git commit -a -m '{{ message }}' || true && git pull && git push

check:
    hk check --all

fix:
    hk fix --all
