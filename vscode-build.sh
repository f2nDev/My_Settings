#!/bin/bash

# エラーが発生したら即終了
set -e

if [ $(id -u) -eq 0 ];then
    echo "This script must not run as root because root can't find vscode."
    exit 1
fi

if ! type code &> /dev/null; then
    echo "VS Code didn't exist."
    exit 1
fi

# install extensions
code --install-extension usernamehw.errorlens --force
code --install-extension ms-python.python --force
code --install-extension ms-python.vscode-pylance --force
code --install-extension esbenp.prettier-vscode --force
code --install-extension vscodevim.vim --force