#!/bin/sh

backup_folder=~/.backup_before_dotfiles_install
mkdir $backup_folder

if [ -f ~/.bashrc ]; then
    mv ~/.bashrc $backup_folder/
fi
ln -s ~/dotfiles/bashrc ~/.bashrc

if [ -f ~/.tmux.conf ]; then
    mv ~/.tmux.conf $backup_folder/
fi
ln -s ~/dotfiles/tmux.conf ~/.tmux.conf

if [ -f ~/.vimrc ]; then
    mv ~/.vimrc $backup_folder/
fi
ln -s ~/dotfiles/vimrc ~/.vimrc

if [ -f ~/.vimrc.bundles ]; then
    mv ~/.vimrc.bundles $backup_folder/
fi
ln -s ~/dotfiles/vimrc.bundles ~/.vimrc.bundles

if [ -f ~/.zshrc ]; then
    mv ~/.zshrc $backup_folder/
fi
ln -s ~/dotfiles/zshrc ~/.zshrc

if [ -f ~/.gitconfig ]; then
    mv ~/.gitconfig $backup_folder/
fi
ln -s ~/dotfiles/gitconfig ~/.gitconfig

mkdir -p ~/bin

#ln -s ~/dotfiles/bin/open_in_idea.sh ~/bin/open_in_idea.sh

#ln -s ~/dotfiles/config/vscode/settings.json ~/.config/Code/User/settings.json
ln -s ~/dotfiles/config/vscode/keybindings.json ~/.config/Code/User/keybindings.json
#ln -s ~/dotfiles/config/vscode/snippets ~/.config/Code/User/snippets  

#vscode
mkdir -p ~/.config/Code/User || true
for file in ~/dotfiles/config/vscode/*; do
    rm -f ~/.config/Code/User/$(basename $file) || true
    ln -sf "$file" ~/.config/Code/User/
done

#sublime
ln -sf /home/daniel/dotfiles/config/sublime-text-3 /home/daniel/.config/sublime-text/Packages/User

git clone https://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
