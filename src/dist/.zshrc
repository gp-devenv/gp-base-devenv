# Set up the prompt
export LANG="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
# export LC_ALL="en_US.UTF-8"

# Starship
eval "$(starship init zsh)"

# Run setup (only once)
if [ -f ~/setup.sh ]; then
    echo "It seems that you are login for the first time or you haven't run the setup script yet"
    echo ""
    echo "Run:"
    echo "    $ ./setup.sh"
fi
