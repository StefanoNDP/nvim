#!/usr/bin/env bash

if ! [ "$EUID" -ne 0 ]; then
  echo
  echo "Don't run this script as root"
  echo
  sleep 1s
  exit 1
fi

# For server using debian
#sudo apt install -y clang clangd clang-tools clang-format clang-tidy cmake cmake-extras && sync

export DOTNET_CLI_TELEMETRY_OPTOUT=1
export PATH=$PATH:/snap/bin:$HOME/.local/bin:$HOME/.cargo/bin

HOMEPATH="$HOME"
APPSPATH="$HOMEPATH"/.apps
DOTFILESPATH="$HOMEPATH"/dotfiles

if ! [ -d "$HOMEPATH"/.vim/undodir ]; then
  mkdir -p "$HOMEPATH"/.vim/undodir
fi
if ! [ -d "$HOMEPATH"/.cache/ccls ]; then
  mkdir -p "$HOMEPATH"/.cache/ccls
fi
if ! [ -d "$APPSPATH" ]; then
  mkdir "$HOMEPATH"/.apps
fi

ln -svf "$DOTFILESPATH"/.config/tmux "$HOMEPATH"/.config/
ln -svf "$DOTFILESPATH"/.config/nvim "$HOMEPATH"/.config/

ln -svf "$DOTFILESPATH"/.editorconfig "$HOMEPATH"/
ln -svf "$DOTFILESPATH"/.clang-format "$HOMEPATH"/

sudo add-apt-repository universe

wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

mkdir -p ~/.local/share/fonts

sudo apt update && sudo apt upgrade -y

# Apt - Neovim
PKGA=(
  # Dev
  'build-essential'
  'libssl-dev'
  'libreadline-dev'
  'zlib1g-dev'
  'rustc'
  'cargo'
  'rustfmt'
  'nodejs'
  'unzip'
  'gettext'
  'wget'
  'git'
  'make'
  'fzf'
  'bat'
  'zoxide'
  'eza'
  'xclip'
  'xsel'
  'ninja-build'
  'curl'
  'ccache'
  'libreadline-dev'
  'g++-14'
  'g++-14-multilib'
  'gcc-14'
  'gcc-14-multilib'
  'cmake'        # CMake Software Builder
  'cmake-extras' # CMake Addons
  'llvm'
  'clang' # C family goodie
  'clangd'
  'clang-tools'
  'clang-format'
  'clang-tidy'
  'automake'
  'libtool'
  'premake4'
  'bear'
  'lldb'
  'gdb'
  'universal-ctags'
  'doxygen'
  'texlive-bin'
  'texlive-latex-recommended'
  'texlive-latex-extra'

  # Tmux
  'tmux'

  # Neovim
  'luarocks'
  'ripgrep' # Better "grep"
  'fd-find' # Better "find"
  'shfmt'
  'shellcheck'
  'python3-pip'
  'python3-argcomplete'
  'python3'
  'pipx'
  'imagemagick'

  # Kitty
  'kitty'
  'kitty-shell-integration'
  'kitty-terminfo'

  # Misc
  'fonts-inter'

  # C Sharp
  'dotnet-sdk-9.0'
  'aspnetcore-runtime-9.0'
  'dotnet-targeting-pack-9.0'
  'aspnetcore-targeting-pack-9.0'
  'mono-complete'
  'mono-xbuild'
  'libuv1'
  'libuv1-dev'

  # Github
  'gh' # Github cli
)

for PKG in "${PKGA[@]}"; do
  echo
  echo "INSTALLING: ${PKG}"
  echo
  sudo apt install -y "$PKG"
  sync
  sleep 1s
done

# Apt - Neovim
PKGB=(
  'ispc'
  'rustup'
)

for PKG in "${PKGB[@]}"; do
  echo
  echo "INSTALLING: ${PKG}"
  echo
  sudo snap install "$PKG" --classic
  sync
  sleep 1s
done

NVM_VERSION=$(curl -s "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*') &&
  curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh" | bash &&
  export NVM_DIR="$HOMEPATH/.config/nvm" &&
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" &&
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

nvm install --latest-npm node && sync

cd $APPSPATH

FONTS_VERSION=$(curl -s "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo JetBrainsMono-${FONTS_VERSION}.tar.xz "https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONTS_VERSION}/JetBrainsMono.tar.xz" && sync
tar -xf JetBrainsMono-${FONTS_VERSION}.tar.xz && sync
mv *.ttf ~/.locaL/share/fonts/ && sync
fc-cache -fv

git clone --depth=1 https://github.com/neovim/neovim.git
git clone --depth=1 https://github.com/LuaLS/lua-language-server.git
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit-${LAZYGIT_VERSION}.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
curl -Lo lua-5.4.7.tar.gz https://www.lua.org/ftp/lua-5.4.7.tar.gz
curl -Lo luarocks-3.11.1.tar.gz https://luarocks.github.io/luarocks/releases/luarocks-3.11.1.tar.gz

tar -xf lazygit-${LAZYGIT_VERSION}.tar.gz
tar -xf lua-5.4.7.tar.gz
tar -xf luarocks-3.11.1.tar.gz

sudo install lazygit -D -t /usr/local/bin/

cd $APPSPATH/lua-5.4.7
make all test && sync && sudo make install && sync

cd $APPSPATH/luarocks-3.11.1
./configure --with-lua-include=/usr/local/include && sync && make && sync && sudo make install && sync

luarocks config local_by_default true
luarocks install lua-utils

cd $APPSPATH/lua-language-server
./make.sh

cd $APPSPATH/neovim
make CMAKE_BUILD_TYPE=Release
sudo make install

# PIP
PKGD=(
  # nvim Dependencies
  'pynvim'
  'cmake-language-server'
  'ue4cli'
  'gdtoolkit'
  'grip'
  'rollnw'
  'arclight'
  'hererocks'
)

for PKG in "${PKGD[@]}"; do
  echo
  echo "INSTALLING: ${PKG}"
  echo
  CC=cc python3 -m pip install --user --upgrade --break-system-packages "$PKG"
  sync
done

rustup install stable

rustup target install i686-unknown-linux-gnu

rustup default stable

cargo install async-cmd

cargo install shellharden

npm install --global all-the-package-names

npm install -g npm@latest

# npm i --package-lock-only
# sync

npm audit fix
sync

# NPM
PKGE=(
  # LSP
  # 'vscode-langservers-extracted'
  'bash-language-server'
  'tailwindcss-language-server'
  'typescript'
  'typescript-language-server'
  'yarn'
  '@vscode/vsce'
  'fish-lsp'
  '@fsouza/prettierd'
  'tree-sitter-cli'
)

for PKG in "${PKGE[@]}"; do
  echo
  echo "INSTALLING: ${PKG}"
  echo
  npm i -g "$PKG"
  sync
  sleep 1s
done

npm audit fix
sync

PKGE=(
  # LSP
  'csharp-ls'
  'csharpier'
)

for PKG in "${PKGE[@]}"; do
  echo
  echo "INSTALLING: ${PKG}"
  echo
  dotnet tool install --global "$PKG"
  sync
  sleep 1s
done

."$HOMEPATH"/.tmux/plugins/tpm/bin/install_plugins
sync

cd "$HOMEPATH"/.config/tmux/plugins/tmux-thumbs
cargo build --release
sync

tmux source "$HOMEPATH"/.config/tmux/tmux.conf
sync

printf "export PATH=\$PATH:/snap/bin:\$HOME/.local/bin:\$HOME/.cargo/bin\n" | tee -a ~/.bashrc
printf "\nDOTNET_CLI_TELEMETRY_OPTOUT=1\n" | sudo tee -a /etc/environment
printf "FrameworkPathOverride=/lib/mono/4.8-api\n" | sudo tee -a /etc/environment

echo
echo "Done"
# echo "Press alt+space shift+i to install tmux plugins and WAIT"
echo
sync
exit 0
