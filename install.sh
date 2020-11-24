#!/usr/bin/env bash

set -e
set -u
set -o pipefail

is_app_installed() {
  type "$1" &>/dev/null
}

REPODIR="$(cd "$(dirname "$0")"; pwd -P)"
cd "$REPODIR";

if ! is_app_installed tmux; then
  printf "WARNING: \"tmux\" command is not found. \
Install it first\n"
  exit 1
fi

if [ ! -e "$HOME/.tmux/plugins/tpm" ]; then
  printf "WARNING: Cannot found TPM (Tmux Plugin Manager) \
 at default location: \$HOME/.tmux/plugins/tpm.\n"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [ -e "$HOME/.tmux.conf" ]; then
  printf "Found existing .tmux.conf in your \$HOME directory. Will create a backup at $HOME/.tmux.conf.bak\n"
fi

rm -rf "$HOME"/.vimrc
cp -f "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak" 2>/dev/null || true
cp -a ./tmux/. "$HOME"/.tmux/
ln -sf .tmux/tmux.conf "$HOME"/.tmux.conf;

# Install TPM plugins.
# TPM requires running tmux server, as soon as `tmux start-server` does not work
# create dump __noop session in detached mode, and kill it when plugins are installed
printf "Install TPM plugins\n"
tmux new -d -s __noop >/dev/null 2>&1 || true 
tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "~/.tmux/plugins"
"$HOME"/.tmux/plugins/tpm/bin/install_plugins || true
tmux kill-session -t __noop >/dev/null 2>&1 || true

apt-get install software-properties-common
add-apt-repository ppa:deadsnakes/ppa 
apt-get update
apt-get install -y python3.8 python3.8-dev vim-gtk git gcc libncurses5-dev libncursesw5-dev
cd /tmp && git clone https://github.com/vim/vim.git
cd /tmp/vim
make clean distclean
" ls -lh /usr/bin/ | grep python3
" ls /usr/lib/python3.8/config-
sudo ./configure --enable-python3interp --with-python3-command=/usr/bin/python3.8 -with-python3-config-dir=/usr/lib/python3.8/config-3.8-x86_64-linux-gnu
make && sudo make install

sudo ln -s /usr/bin/python3.8 /usr/bin/python3
  
vim --version

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


apt-key adv --keyserver pgp.mit.edu --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb http://download.mono-project.com/repo/debian wheezy main" > /etc/apt/sources.list.d/mono-xamarin.list
apt-get update
apt-get install mono-devel

" Install netcoredbg
mkdir ~/netcoredbg/bin/
wget https://github.com/lextudio/monodevelop.netcoredbg/releases/download/v1.0/netcoredbg.linux.zip
unzip ~/netcoredbg/bin/netcoredbg.linux.zip
rm -rf ~/netcoredbg/bin/netcoredbg.linux.zip
ln -s ~/netcoredbg/bin/netcoredbg /usr/bin/netcoredbg

vim +PluginInstall +qall


printf "OK: Completed\n"
