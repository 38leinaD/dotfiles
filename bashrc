tmx() { tmux attach -t $1 || tmux new -s $1; }

if [ -f ~/.bashrc.local ]; then
  source ~/.bashrc.local
fi
