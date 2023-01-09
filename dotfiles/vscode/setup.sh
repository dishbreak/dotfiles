#!/bin/bash

USAGE=$(cat <<EOF

    Usage:
        $0 (capture|install)
    Commands:
        capture     write existing extensions to extensions.txt
        install     install extensions listed in extensions.txt
EOF
)

EXTENSIONS_TXT_PATH="$(dirname $0)/extensions.txt"

VSCODE_NOT_SETUP=$(cat <<EOF
VSCode CLI not set up! Make sure it is installed and set up.
Additionally, ensure that you have set up the code CLI command:
https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line
EOF
)

if ! which code > /dev/null; then
    ( >&2 echo "$VSCODE_NOT_SETUP")
    exit 1
fi

if [[ $# -ne 1 ]]; then
    (>&2 echo "Need exactly 1 argument. $USAGE")
    exit 3
fi

capture_extensions() {
    code --list-extensions > "${EXTENSIONS_TXT_PATH}"
    echo "updated $EXTENSIONS_TXT_PATH"
    echo "make sure to commit this file if needed"
}

install_extensions() {
    while read p; do
        code --install-extension "$p" --force
    done < "$EXTENSIONS_TXT_PATH"
}

case $1 in 
    capture )
        capture_extensions
        ;;
    install )
        install_extensions
        ;;
    * )
        (>&2 echo "unrecognized command $0. $USAGE")
        exit 4
        ;;
esac


