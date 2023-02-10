#!/bin/sh

set -e

echo "Setup tmux..."
tmux -c 'tmux source ~/.tmux.conf'
tmux -c '~/.tmux/plugins/tpm/bin/install_plugins'

echo "\nSetup vim..."
vim --not-a-term +'PlugInstall --sync' +qall 

rm $0
