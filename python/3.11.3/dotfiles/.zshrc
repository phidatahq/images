
# Load zsh theme
export ZSH=/root/.oh-my-zsh
ZSH_THEME="phi"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#b8a2ff"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(git python colorize zsh-syntax-highlighting zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh
