#!/bin/bash
branch=$1
shell=$2

shopt -s expand_aliases
alias config='/usr/bin/git --git-dir=$HOME/.cfg --work-tree=$HOME'

dotconfig() {
	echo ".cfg" >> .gitconfig
	config stash -a
	config init
	config remote add origin https://github.com/mroberts14/dotfiles.git
	config fetch origin
	config config --local status.showUntrackedFiles no
	config checkout $branch -f
}

zshconfig() {
	if [[ -d "$HOME/.oh-my-zsh" ]]; then
		echo "oh my zsh is already installed"
	else
		sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
		sh chsh -s $(which zsh) $(whoami)
	fi
}

if [[ ! -d "$HOME/.cfg" ]]; then
  dotconfig
else
	rm -rf .cfg
        dotconfig
fi

if [[ $shell == zsh ]]; then
	zshconfig
	zshcustom
fi

