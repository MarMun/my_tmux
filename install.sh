#! /bin/bash
os=$(uname)
conf="$HOME/.my_tmux/.tmux.conf"
create_symlink=true

# If .tmux.conf already exists...
if [ -e ~/.tmux.conf ]; then
  # ... ask user to replace it
  read -p "~/.tmux.conf already exists. Do you really want to replace it (I would create a symlink?) (y/n): " choice
  if [ "$choice" != "y" ] && [ "$choice" != "Y" ]; then
    create_symlink=false
  fi
fi

if [ "$create_symlink" == "true" ]; then
  # ... create softlink to config
  ln -s $conf ~/.tmux.conf
else
  echo "~/.tmux.conf already exists. Skipping symlink creation."
fi

# Install clipboard tool on Linux
# (Darwin has 'pbcopy' preinstalled)
if [ "$os" == "Linux" ]; then
  sudo apt install xclip
fi

if grep -q "bind -T copy-mode-vi Enter" $conf; then
  echo "Bind command already exists in .tmux.conf. Skipping."
  exit 0
fi 

# Append clipboard tool to .tmux.conf
if [ "$os" == "Linux" ]; then
  echo "bind -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel 'xclip -sel clip -i'" >> $conf
else
  # Darwin
  echo "bind -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel 'pbcopy'" >> $conf
fi


