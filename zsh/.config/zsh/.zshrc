# Path to oh-my-zsh installation.
export ZSH="${ZDOTDIR}"

# Set OMZ theme
ZSH_THEME="agnoster"

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
)

source "${ZSH}/oh-my-zsh.sh"

wttr() {
    curl https://wttr.in/${1:-Bhubaneswar}
}

# PATH
export PATH="${HOME}/.emacs.d/bin:${HOME}/.local/bin:${PATH}"

# GO
export GOPATH="${HOME}/.go"
export GOBIN="${HOME}/.local/bin"

# ZSH
# Fetch suggestions asynchronously
export ZSH_AUTOSUGGEST_USE_ASYNC=1
# order of strategies to try
export ZSH_AUTOSUGGEST_STRATEGY=(
    match_prev_cmd
    completion
)
# Avoid autosuggestions for buffers that are too large
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

if command -v kitty 2>/dev/null 1>&2; then
    alias icat="kitty +kitten icat"
fi

if [[ -d "${HOME}/.config/emacs" ]]; then
    if command -v vim 2>/dev/null 1>&2; then
        alias vimreally=$(command -v vim)
    elif command -v nvim 2>/dev/null 1>&2; then
        alias vimreally=$(command -v nvim)
    fi

    alias vim='emacsclient -tty'
    alias nvim='vim'
fi

if [[ -f /usr/share/nvm/init-nvm.sh ]]; then
    source /usr/share/nvm/init-nvm.sh
fi