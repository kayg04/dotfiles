# Path to oh-my-zsh installation.
export ZSH="/home/kayg/.config/omz"

# Set OMZ theme
ZSH_THEME="fox"

# _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Enable command auto-correction.
ENABLE_CORRECTION="true"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
)

source $ZSH/oh-my-zsh.sh

wttr() {
    curl https://wttr.in/${1:-Bhubaneswar}
}

export PATH="${PATH}:${HOME}/.local/bin"
export GOPATH="${HOME}/.go"
export GOBIN="${HOME}/.local/bin"
