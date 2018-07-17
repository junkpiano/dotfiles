#! /usr/bin/env bash

prepare() {
	git submodule init
	git submodule update
}

bootstrap() {
	if [[ $(uname) == 'Darwin' ]]; then
    	sh laptop/mac 2>&1 | tee ~/laptop.log
	fi

	npm install --global pure-prompt
}

reloadConf() {
	find . -maxdepth 1 \
	-iname '.*' -not -iname '.git*' -not -iname '.' \
	-exec sh -c '
	echo "creating a symbolic link to $1 ..."
	rm -rf "${HOME}/$1" || continue
	ln -s ${PWD}/$1 ${HOME}/$1
	' sh {} \;

	rm "${HOME:?}"/.oh-my-zsh    
	ln -s "${PWD}"/oh-my-zsh "$HOME"/.oh-my-zsh

	exec "$SHELL" -l
}

subcommand=$1

prepare

case $subcommand in
	"bootstrap") bootstrap ;;
	*) ;;
esac

reloadConf
