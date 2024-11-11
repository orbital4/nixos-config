################################################################################
# Keymaps
################################################################################
bind '"\C-k": history-search-backward'
bind '"\C-j": history-search-forward'

################################################################################
# lf
################################################################################
# Change working dir in shell to last dir in lf on exit (adapted from ranger).
lf () {
    # `command` is needed in case `lfcd` is aliased to `lf`
    cd "$(command lf -print-last-dir "$@")"
}

################################################################################
# PS1
################################################################################
get_os() {
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        if [[ "$ID" == "nixos" ]]; then
            echo "$(tput setaf 4)$(tput sgr0)"
        else
            echo "$ID"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "mac"
    else
        echo "unknown"
    fi
}

parse_git_info() {
    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        # Get the repo directory name
        local repo_dir=$(basename $(git rev-parse --show-toplevel 2>/dev/null))
        local staged=$(git diff --staged --quiet || echo "*")
        local unstaged=$(git diff --quiet || echo "!")
        local untracked=$(git ls-files --others --exclude-standard | grep -q . && echo "?")
        echo "${repo_dir}/${branch}${staged}${unstaged}${untracked}"
    fi
}

# The PS1 configuration - note that we removed the color code for OS since it's now in the get_os function
PS1='$(get_os)  \
\[$(tput bold)$(tput setaf 2)\]$(whoami)\[$(tput sgr0)\] \
\[$(tput bold)$(tput setaf 5)\]\w\[$(tput sgr0)\] \
\[$(tput bold)$(tput setaf 4)\]$(parse_git_info)\[$(tput sgr0)\]\n\
> '

################################################################################
# Zoxide
################################################################################
eval "$(zoxide init bash)"
