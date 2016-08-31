DOTFILES := $(shell pwd)

all: dev vim snippets hammerspoon tmux zsh

zsh:
	ln -fs $(DOTFILES)/zsh/zpreztorc.symlink ${HOME}/.zpreztorc
	ln -fs $(DOTFILES)/zsh/zshenv.symlink ${HOME}/.zshenv
	ln -fs $(DOTFILES)/zsh/zprofile.symlink ${HOME}/.zprofile
	ln -fs $(DOTFILES)/zsh/zshrc.symlink ${HOME}/.zshrc

dev:
	ln -fs $(DOTFILES)/ack/ackrc.symlink ${HOME}/.ackrc

hammerspoon:
	mkdir ${HOME}/.hammerspoon
	ln -fs $(DOTFILES)/hammerspoon/init.lua ${HOME}/.hammerspoon/init.lua

vim:
	ln -fs $(DOTFILES)/vim/vimrc.symlink ${HOME}/.vimrc

snippets:
	mkdir -p ${HOME}/.vim/snips
	ln -fs $(DOTFILES)/snips/gitcommit.snippets ${HOME}/.vim/snips/gitcommit.snippets
	ln -fs $(DOTFILES)/snips/htmldjango.snippets ${HOME}/.vim/snips/htmldjango.snippets
	ln -fs $(DOTFILES)/snips/jinja.snippets ${HOME}/.vim/snips/jinja.snippets
	ln -fs $(DOTFILES)/snips/javascript.snippets ${HOME}/.vim/snips/javascript.snippets
	ln -fs $(DOTFILES)/snips/python.snippets ${HOME}/.vim/snips/python.snippets

prompt:
	ln -fs $(DOTFILES)/prompt/pure.zsh ${HOME}/.zprezto/modules/prompt/functions/prompt_pure_setup

services:
	mkdir ${HOME}/.services
	ln -fs $(DOTFILES)/services/screen-to-cloudup.sh ${HOME}/.services/screen-to-cloudup/screen-to-cloudup

tmux:
	ln -fs $(DOTFILES)/tmux/tmux.conf ${HOME}/.tmux.conf
