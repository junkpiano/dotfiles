#! /usr/bin/env bash

prepare() {
	git submodule init
	git submodule update
}

bootstrap() {
	if [[ $(uname) == 'Darwin' ]]; then
    	sh laptop/mac 2>&1 | tee ~/laptop.log
	    npm install --global pure-prompt
		brew bundle
	elif [[ $(uname) == 'Linux' ]]; then
	    # install `asdf`
	    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.7.8
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

	if [[ -d ${HOME}/.oh-my-zsh ]]
	then
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
