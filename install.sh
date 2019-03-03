#!/usr/bin/sh

ln -s ~/dotfiles/bashrc ~/.bashrc
ln -s ~/dotfiles/tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/vimrc ~/.vimrc
ln -s ~/dotfiles/vimrc.bundles ~/.vimrc.bundles
ln -s ~/dotfiles/zshrc ~/.zshrc
ln -s ~/dotfiles/gitconfig ~/.gitconfig

ln -s ~/dotfiles/config/vscode/settings.json ~/.config/Code/User/settings.json
ln -s ~/dotfiles/config/vscode/keybindings.json ~/.config/Code/User/keybindings.json
ln -s ~/dotfiles/config/vscode/snippets ~/.config/Code/User/snippets  

#vscode
mkdir -p ~/.config/Code/User
for file in ~/dotfiles/config/vscode/*; do
    ln -sf "$file" ~/.config/Code/User/
done

#sublime
mkdir -p /home/daniel/.config/sublime-text-3/Packages/User
for file in /home/daniel/dotfiles/config/sublime-text-3/*; do
	ln -sf "$file" /home/daniel/.config/sublime-text-3/Packages/User/
done

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install