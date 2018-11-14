DOTFILES := $(shell pwd)

all: dev vim hammerspoon zsh

zsh:
	ln -fs $(DOTFILES)/zsh/zpreztorc.symlink ${HOME}/.zpreztorc
	ln -fs $(DOTFILES)/zsh/zshenv.symlink ${HOME}/.zshenv
	ln -fs $(DOTFILES)/zsh/zprofile.symlink ${HOME}/.zprofile
	ln -fs $(DOTFILES)/zsh/zshrc.symlink ${HOME}/.zshrc

dev:
	ln -fs $(DOTFILES)/ack/ackrc.symlink ${HOME}/.ackrc

hammerspoon:
	mkdir -p ${HOME}/.hammerspoon
	ln -fs $(DOTFILES)/hammerspoon/init.lua ${HOME}/.hammerspoon/init.lua

vim:
	ln -fs $(DOTFILES)/vim/vimrc.symlink ${HOME}/.vimrc
