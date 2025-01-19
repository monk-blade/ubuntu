# Aliases
source $HOME/.config/fish/aliases.fish

# Abbreviations
source $HOME/.config/fish/abbr.fish

#zoxide setup
zoxide init fish | source

#mise setup 
/usr/bin/mise activate fish | source

#Rust setup
source "$HOME/.cargo/env.fish"

# Setup starship prompt
starship init fish | source
if status is-interactive
    # Commands to run in interactive sessions can go here
end
