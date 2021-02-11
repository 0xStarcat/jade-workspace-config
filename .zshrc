
READNULLCMD=${PAGER:-/usr/bin/pager}

# An array to note missing features to ease diagnosis in case of problems.
typeset -ga debian_missing_features

if [[ -z "${DEBIAN_PREVENT_KEYBOARD_CHANGES-}" ]] &&
   [[ "$TERM" != 'emacs' ]]
then

    typeset -A key
    key=(
        BackSpace  "${terminfo[kbs]}"
        Home       "${terminfo[khome]}"
        End        "${terminfo[kend]}"
        Insert     "${terminfo[kich1]}"
        Delete     "${terminfo[kdch1]}"
        Up         "${terminfo[kcuu1]}"
        Down       "${terminfo[kcud1]}"
        Left       "${terminfo[kcub1]}"
        Right      "${terminfo[kcuf1]}"
        PageUp     "${terminfo[kpp]}"
        PageDown   "${terminfo[knp]}"
    )

    function bind2maps () {
        local i sequence widget
        local -a maps

        while [[ "$1" != "--" ]]; do
            maps+=( "$1" )
            shift
        done
        shift

        sequence="${key[$1]}"
        widget="$2"

        [[ -z "$sequence" ]] && return 1

        for i in "${maps[@]}"; do
            bindkey -M "$i" "$sequence" "$widget"
        done
    }

    bind2maps emacs             -- BackSpace   backward-delete-char
    bind2maps       viins       -- BackSpace   vi-backward-delete-char
    bind2maps             vicmd -- BackSpace   vi-backward-char
    bind2maps emacs             -- Home        beginning-of-line
    bind2maps       viins vicmd -- Home        vi-beginning-of-line
    bind2maps emacs             -- End         end-of-line
    bind2maps       viins vicmd -- End         vi-end-of-line
    bind2maps emacs viins       -- Insert      overwrite-mode
    bind2maps             vicmd -- Insert      vi-insert
    bind2maps emacs             -- Delete      delete-char
    bind2maps       viins vicmd -- Delete      vi-delete-char
    bind2maps emacs viins vicmd -- Up          up-line-or-history
    bind2maps emacs viins vicmd -- Down        down-line-or-history
    bind2maps emacs             -- Left        backward-char
    bind2maps       viins vicmd -- Left        vi-backward-char
    bind2maps emacs             -- Right       forward-char
    bind2maps       viins vicmd -- Right       vi-forward-char

    # Make sure the terminal is in application mode, when zle is
    # active. Only then are the values from $terminfo valid.
    if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
        function zle-line-init () {
            emulate -L zsh
            printf '%s' ${terminfo[smkx]}
        }
        function zle-line-finish () {
            emulate -L zsh
            printf '%s' ${terminfo[rmkx]}
        }
        zle -N zle-line-init
        zle -N zle-line-finish
    else
        for i in {s,r}mkx; do
            (( ${+terminfo[$i]} )) || debian_missing_features+=($i)
        done
        unset i
    fi

    unfunction bind2maps

fi # [[ -z "$DEBIAN_PREVENT_KEYBOARD_CHANGES" ]] && [[ "$TERM" != 'emacs' ]]


# NVM
export NVM_DIR="$HOME/.nvm"
  [ -s "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh" ] && . "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# PYENV

export PATH="/home/angel/.pyenv/bin:$PATH"

export ZSH="$HOME/.oh-my-zsh"
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:$HOME/bin:$HOME/.local/bin:/home/angel/anaconda3/bin:$PATH
#
export TERM=xterm-256color        # for common 256 color terminals (e.g. gnome-terminal)
# export TERM=screen-256color       # for a tmux -2 session (also for screen)
# export TERM=rxvt-unicode-256color # for a colorful rxvt unicode session
# export DIRCOLORTHEME='dircolors.ansi-dark'

ZSH_THEME="powerlevel10k/powerlevel10k"

POWERLEVEL9K_MODE="nerdfont-complete"
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon time user host root_indicator background_jobs status dir_writable dir vcs)
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs time context)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='%(?:%{$fg_bold[magenta]%}\uf7d3 ➜ :%{$fg_bold[red]%}\uf7d3 ➜ )'

#POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
# POWERLEVEL9K_LINUX_ICON='\uf300'
POWERLEVEL9K_USER_ICON="\uf004" # 
POWERLEVEL9K_HOST_ICON="\u0040" # 
POWERLEVEL9K_ROOT_ICON="\uf21e"
POWERLEVEL9K_SUDO_ICON=$'\uf21e' # 
POWERLEVEL9K_TIME_FORMAT="%D{%H:%M}"
# POWERLEVEL9K_VCS_GIT_ICON='\uF408 '
POWERLEVEL9K_VCS_GIT_GITHUB_ICON='\uf1d3'
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='red'

# https://github.com/romkatv/powerlevel10k/blob/master/README.md#horrific-mess-when-resizing-terminal-window

POWERLEVEL9K_SHOW_RULER=false
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR=' '
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX=''
POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_SUFFIX=''
POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX=''

# autocompletion
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin \
                                           /usr/local/bin  \
                                           /usr/sbin       \
                                           /usr/bin        \
                                           /sbin           \
                                           /bin            \
                                           /usr/X11R6/bin

(( ${+aliases[run-help]} )) && unalias run-help
autoload -Uz run-help

# If you don't want compinit called here, place the line
# skip_global_compinit=1
# in your $ZDOTDIR/.zshenv
if grep -q '^ID.*=.*ubuntu' /etc/os-release && [[ -z "$skip_global_compinit" ]]; then
  autoload -U compinit
  compinit
fi

zstyle :compinstall filename '/home/angel/.zshrc'

autoload -Uz compinit
compinit

# go backwards w/ shift+tab
bindkey '^[[Z' reverse-menu-complete


# case insensitive matching if no case-sensitive matches exist
# https://superuser.com/questions/1092033/how-can-i-make-zsh-tab-completion-fix-capitalization-errors-for-directories-and
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
# zstyle :completion::complete:-command-:: tag-order local-directories -
# zstyle ':completion:*' insert-tab false

ZSH_DISABLE_COMPFIX=true


ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

plugins=(
  git
  iterm2
  macports
  man
  osx
  python
  composer
)


# source ~/.bash_profile

if [ -f ~/.bash_profile ]; then
    . ~/.bash_profile;
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory notify
unsetopt beep extendedglob
bindkey -e



# PROMPT
# PS1='%U%B%n@%m%u:%b%~ - %B%b$(git_super_status)
#  %{%F{red}%}<3%{%F{white}%} '

# Tilix fix
# if missing, need to symlink
# sudo ln -s /etc/profile.d/vte-2.91.sh /etc/profile.d/vte.sh
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi


source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme


# source $HOME/.zsh-plugins/zsh-git-prompt/zshrc.sh # Zsh git prompt
# source $ZSH/oh-my-zsh.sh
source $HOME/.aliases
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh



# EVALS
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi

# brew
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
# rbenv
eval "$(rbenv init -)"
# pyenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"



# fix NVM NPM slowdown
# https://github.com/nvm-sh/nvm/issues/539#issuecomment-245791291
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" --no-use # This loads nvm

alias node='unalias node ; unalias npm ; nvm use default ; node $@'
alias npm='unalias node ; unalias npm ; nvm use default ; npm $@'
