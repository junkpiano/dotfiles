dotfiles
=============

These are my dotfiles.
`setup.bash` is checked with [shellcheck](https://github.com/koalaman/shellcheck).

Bootstrap
--------------

    $ ./setup.bash bootstrap

Run this for only the first time to bootstrap this dotfile environment.

Reload Configurations
----------------------

    $ ./setup.bash
    $ source ${HOME}/.zshrc

Without `bootstrap`, it just reloads configurations, which is actually creating symbolic links again.

Zsh Plugins
--------------

- [robbyrussell/oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
- [sindresorhus/pure](https://github.com/sindresorhus/pure)
- [zsh-users/zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)

Color Theme
--------------

## For MacOS

| iTerm2 |
| :------------- |
| [sindresorhus/iTerm2-snazzy](https://github.com/sindresorhus/iterm2-snazzy) |

## For Windows

*under construction*

References
------------------

- https://junkpiano.github.io/dotfiles
