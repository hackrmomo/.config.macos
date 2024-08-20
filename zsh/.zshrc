# Lines configured by zsh-newuser-install
HISTFILE=~/.config/zsh/.histfile
HISTSIZE=50000
SAVEHIST=50000
setopt autocd extendedglob nomatch notify
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/Users/hackr/.config/zsh/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

###############################################################################
# ENVIRONMENT VARIABLES                                                       #
###############################################################################

export PATH="$PATH:/opt/homebrew/bin"
export PATH="$PATH:/opt/homebrew/sbin"
export NVM_DIR="$HOME/.nvm"

###############################################################################
# EVALUATION FUNCTIONS AND LOADERS                                            #
###############################################################################

eval "$(starship init zsh)"
eval "$(atuin init zsh)"
eval "$(zoxide init zsh)"
source <(fzf --zsh)
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

###############################################################################
# ALIASES AND FUNCTIONS                                                       #
###############################################################################

alias rebuild="darwin-rebuild switch --flake ~/.config/nix-darwin"
alias pip="python3 -m pip"
alias g="git"
alias gc="git commit -m"
alias gp="git push"
alias gl="git pull"
alias gco="git checkout"
alias cl="clear"
alias l="ls -lah"