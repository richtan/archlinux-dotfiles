#! /usr/bin/zsh

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Startup time profiling
# zmodload zsh/zprof

if [ ! -d "${HOME}/.zgen" ]; then
  git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
fi

if [ ! -d "${HOME}/.pyenv" ]; then
  curl https://pyenv.run | bash
fi

source "${HOME}/.zgen/zgen.zsh"

if ! zgen saved; then
  echo "Creating a zgen save..."
  zgen oh-my-zsh

  OMZ_PLUGINS=(
    colored-man-pages
    django
    pip
    pyenv
    last-working-dir
  )
  for omz_plugin in $OMZ_PLUGINS; do
    zgen oh-my-zsh plugins/$omz_plugin
  done

  PLUGINS=(
    laggardkernel/git-ignore
    gradle/gradle-completion
    hlissner/zsh-autopair
    zdharma/fast-syntax-highlighting
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-completions
  )

  for plugin in $PLUGINS; do
    zgen load $plugin
  done

  zgen load romkatv/powerlevel10k powerlevel10k.zsh-theme

  zgen save
fi

export DESKTOP_SESSION="i3"
export DISABLE_UPDATE_PROMPT=true
export EDITOR=vim
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export KEYTIMEOUT=1
export PATH="$PATH:.:$HOME/.local/bin"
export POWERLEVEL9K_TRANSIENT_PROMPT=always
export TERM=xterm-256color
export VISUAL=vim
export parsecd app_daemon=1

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

function chpwd() {
    emulate -L zsh
    ls -A
}

function findup () {
  path=$(pwd)
  while [[ "$path" != "" && ! -e "$path/$1" ]]; do
    path=${path%/*}
  done
  echo "$path/$1"
}

alias ls="lsd"
alias anime-dl="anime dl --quality 1080p -xd \"{aria2}\" --download-dir ~/anime --provider animepahe --episodes "
alias django="python $(findup manage.py)"
alias g="git"
# alias vim="nvim"
# alias vi="noglob vim"
alias xclip="xclip -selection clipboard"
alias cd..="cd .."
alias cd...="cd ..."
alias cls="clear"
alias yt-mp3="youtube-dl --extract-audio --audio-format mp3 -o \"~/music/%(title)s.%(ext)s\""
alias ff="firefox"
alias config="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

[ -f ~/.purepower ]
source ~/.purepower

unsetopt prompt_cr prompt_sp

# fpath+=~/.zfunc
# compinit

# Startup time profiling
# zprof
