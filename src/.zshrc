# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# ZSH Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# -- Aliases -- # 
alias l='exa -l'
alias i="yay -S"
alias r="yay -Rns"
alias s="yay -Ss"
alias o="sudo nvim"
alias gc="git clone"

alias clock="tty-clock -c -t"
alias matrix="cmatrix"
alias info="clear && fastfetch"

alias update="~/.config/hypr/scripts/update_system.sh"
alias kill-waybar="~/.config/hypr/scripts/kill_waybar.sh"
alias launch-waybar="~/.config/hypr/scripts/launch_waybar.sh"
alias reload-waybar="~/.config/hypr/scripts/restart_waybar.sh"

# Add .local/bin to $PATH
export PATH="$HOME/.local/bin:$PATH"

# Plugins
plugins=(git)

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


