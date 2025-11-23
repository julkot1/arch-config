
# Start ssh-agent if not running
eval (ssh-agent -c)

# Add default key (if not already loaded)
# ssh-add ~/.ssh/id_ed25519



if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Aliases
alias ll='ls -lh'
alias la='ls -a'
alias gs='git status'
alias v='nvim'

# Prompt
# Path additions
set -Ux PATH $PATH $HOME/.local/bin

# Environment variables
set -Ux EDITOR nvim
set -Ux BROWSER brave

# Enable vi keybindings
fish_vi_key_bindings

