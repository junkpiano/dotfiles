#! /usr/bin/env bash

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
  if ! command -v brew >/dev/null; then
    fancy_echo "Installing Homebrew ..."
    /bin/bash -c \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    append_to_zshrc "eval \"\$($HOMEBREW_PREFIX/bin/brew shellenv)\""

    export PATH="$HOMEBREW_PREFIX/bin:$PATH"
  fi

  if ! command -v asdf >/dev/null; then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1
    append_to_zshrc ". $HOME/.asdf/asdf.sh"
  fi
}

reloadConf() {
  find . -maxdepth 1 \
    -iname '.*' -not -iname '.git*' -not -iname '.' \
    -exec sh -c '
	echo "creating a symbolic link to $1 ..."
	rm -rf "${HOME}/$1" || continue
	ln -s ${PWD}/$1 ${HOME}/$1
	' sh {} \;

  if [[ -d ${HOME}/.oh-my-zsh ]]; then
    rm "${HOME:?}"/.oh-my-zsh
  fi
  ln -s "${PWD}"/oh-my-zsh "$HOME"/.oh-my-zsh
}

subcommand=$1

prepare

case $subcommand in
"bootstrap") bootstrap ;;
*) ;;
esac

reloadConf

append_to_zshrc "export DOTFILE_PATH=$(pwd)"
