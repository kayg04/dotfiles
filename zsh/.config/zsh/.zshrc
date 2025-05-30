# run TMUX
if [[ -z "${TMUX}" && -d "${HOME}/.tmux" && $(command -v tmux) ]]; then
    exec tmux new-session -As work
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- oh my zsh --- #
# Path to oh-my-zsh installation.
export ZSH="${ZDOTDIR}"

# Set OMZ theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Save history at a custom location
HISTFILE="${ZSH}/.zsh_history"

# Save z's db at a custom location
_Z_DATA="${ZSH}/.z"

# _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Enable command auto-correction.
ENABLE_CORRECTION="true"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Too many plugins slow down shell startup.
# Plugins can be found in $ZSH/plugins
plugins=(
    copyfile
    git
    vi-mode
    z
    zsh-syntax-highlighting
    zsh-autosuggestions
    history-substring-search
)

source "${ZSH}/oh-my-zsh.sh"
# xxx oh my zsh xxx #

# --- functions --- #

# check_if_installed(): a wrapper for `command -v` that silences the output and
# error streams.
#
# use:
#   check_if_installed cmd
check_if_installed() {
    command -v "${1}" 2>/dev/null 1>&2;
}

wttr() {
    curl https://wttr.in/${1:-Delhi}
}

# xxx functions xxx #

# --- variables --- #
export PATH="${HOME}/.local/bin:/opt/homebrew/bin:${PATH}"
export GOBIN="${HOME}/.local/bin"
export GOPATH="${HOME}/.local/lib/go"

# Fetch suggestions asynchronously
export ZSH_AUTOSUGGEST_USE_ASYNC=1
# order of strategies to try
export ZSH_AUTOSUGGEST_STRATEGY=(
    match_prev_cmd
    completion
)
# Avoid autosuggestions for buffers that are too large
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# wsld, X11 over VSOCK
export DISPLAY=:0

# xxx variables xxx #

# --- aliases --- #
if command -v kitty 2>/dev/null 1>&2; then
    alias icat="kitty +kitten icat"
fi

if [[ -d "${HOME}/.config/emacs" || -d "${HOME}/.config/doom" ]]; then
    if command -v vim 2>/dev/null 1>&2; then
        alias vimreally=$(command -v vim)
    fi

    if command -v nvim 2>/dev/null 1>&2; then
        alias nvimreally=$(command -v nvim)
    fi

    alias vim='emacsclient -tty'
    alias nvim='vim'
fi

if [[ -f /usr/share/nvm/init-nvm.sh ]]; then
    source /usr/share/nvm/init-nvm.sh
fi

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# rust utils
check_if_installed bat && alias cat=bat
check_if_installed eza && alias ls=eza
check_if_installed fd && alias find=fd
check_if_installed rg && alias grep=rg
# xxx aliases xxx #
test -e "${ZDOTDIR}/.iterm2_shell_integration.zsh" && source "${ZDOTDIR}/.iterm2_shell_integration.zsh"


. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"

export PATH=$PATH:/Users/kayg/.spicetify
