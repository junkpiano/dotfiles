#!/usr/bin/env bash

set -e

append_to_zshrc() {
  local text="$1" zshrc
  local skip_new_line="${2:-0}"

  if [ -w "$HOME/.zshrc.local" ]; then
    zshrc="$HOME/.zshrc.local"
  else
    zshrc="$HOME/.zshrc"
  fi

  if ! grep -Fqs "$text" "$zshrc"; then
    if [ "$skip_new_line" -eq 1 ]; then
      printf "%s\\n" "$text" >>"$zshrc"
    else
      printf "\\n%s\\n" "$text" >>"$zshrc"
    fi
  fi
}

prepare() {
  git submodule init
  git submodule update
}

bootstrap() {
  if [[ "$(uname)" == "Linux" ]]; then
    sudo apt install build-essential procps curl file git
  fi

  if ! command -v brew >/dev/null; then
    echo "Installing Homebrew ..."
    /bin/bash -c \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if [[ "$(uname)" == "Linux" ]]; then
      test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
      test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi

    append_to_zshrc "eval \"\$($(brew --prefix)/bin/brew shellenv)\""

    export PATH="$(brew --prefix)/bin:$PATH"
  fi

  if ! command -v mise >/dev/null; then
    curl https://mise.run | sh
    append_to_zshrc 'eval "$(~/.local/bin/mise env zsh)"'
  fi
}

reloadConf() {
  find . -maxdepth 1 \
    -iname '.*' -not -iname '.git*' -not -iname '.' \
    -exec sh -c '
	echo "creating a symbolic link to $1 ..."
	rm -rf "${HOME}/$1" || continue
	ln -s "${PWD}/$1" "${HOME}/$1"
	' sh {} \;

  if [[ -d "${HOME}/.oh-my-zsh" ]]; then
    rm -rf "${HOME}/.oh-my-zsh"
  fi
  ln -s "${PWD}/oh-my-zsh" "${HOME}/.oh-my-zsh"
}

subcommand=$1

prepare

case $subcommand in
"bootstrap") 
  bootstrap
  ;;
"")
  # Default behavior - no subcommand
  ;;
*) 
  echo "Unknown subcommand: $subcommand"
  echo "Usage: $0 [bootstrap]"
  exit 1
  ;;
esac

reloadConf

append_to_zshrc "export DOTFILE_PATH=$(pwd)"
