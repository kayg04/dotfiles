wttr() {
    curl https://wttr.in/${1:-Bhubaneswar}
}

export PATH="${PATH}:${HOME}/.local/bin"
export GOPATH="${HOME}/.go"
export GOBIN="${HOME}/.local/bin"
