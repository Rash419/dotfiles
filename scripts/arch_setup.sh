#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to print a step
step() {
  echo -e "${GREEN}==> $1${NC}"
}

# --- Installation Functions ---

install_yay() {
  step "Installing yay (AUR helper)..."
  if command -v yay &>/dev/null; then
    echo "yay is already installed."
    return
  fi

  cd -P /home/$USER/
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd -P ..
  rm -rf yay
}

install_packages() {
  step "Installing base packages..."
  yay -S --noconfirm --needed hyprland kitty sddm xdg-desktop-portal-hyprland hyprpolkitagent uwsm libnewt brightnessctl lsd zoxide fastfetch hyprlock hypridle wlogout wifi-menu bluetui wf-recorder hyprshot hyrshade swaync nvim python-pywal16 starship zsh fzf waybar cliphist wl-clipboard man wget unzip bluez-utils pamixer tmux zsh-vi-mode zsh-autocomplete lazygit spotify qbittorrent libfido2 inetutils

  step "Installing work-related packages..."
  yay -S --noconfirm --needed npm openssh tailscale jdk11-openjdk helm kubectl github-cli minikube docker docker-buildx

  step "Installing Tmux Plugin Manager..."
  if [ ! -d /home/$USER/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm /home/$USER/.tmux/plugins/tpm
  else
    echo "Tmux Plugin Manager already installed."
  fi
}

install_fonts() {
  step "Installing fonts..."

  # Nothingfont
  if [ ! -d /home/$USER/.local/share/fonts/nothing ]; then
    echo "Installing Nothingfonts..."
    mkdir -p /home/$USER/.local/share/fonts/nothing
    git clone https://github.com/xeji01/nothingfont /tmp/nothingfont
    cp -r /tmp/nothingfont/*.ttf /home/$USER/.local/share/fonts/nothing/
    rm -rf /tmp/nothingfont
  else
    echo "Nothingfonts already installed."
  fi

  # DepartureMono
  if [ ! -d /home/$USER/.local/share/fonts/departure-mono ]; then
    echo "Installing DepartureMono..."
    mkdir -p /home/$USER/.local/share/fonts/departure-mono
    wget https://github.com/rektdeckard/departure-mono/releases/download/v1.500/DepartureMono-1.500.zip -O /tmp/DepartureMono.zip
    unzip /tmp/DepartureMono.zip -d /tmp/departure-mono
    cp /tmp/departure-mono/DepartureMono-1.500/*.otf /home/$USER/.local/share/fonts/departure-mono/
    rm -rf /tmp/departure-mono /tmp/DepartureMono.zip
  else
    echo "DepartureMono font already installed."
  fi

  # Other fonts
  yay -S --noconfirm --needed ttf-jetbrains-mono-nerd noto-fonts-emoji rofi-emoji

  step "Updating font cache..."
  fc-cache -f -v
}

enable_services() {
  step "Enabling system services..."
  systemctl --user enable hyprpolkitagent.service
  sudo systemctl enable sddm.service
  sudo systemctl enable bluetooth.service
  sudo systemctl enable docker.service
}

copy_dotfiles() {
  step "Cloning and copying dotfiles..."
  if [ ! -d /home/$USER/dotfiles ]; then
    git clone https://github.com/Rash419/dotfiles /home/$USER/dotfiles
  else
    echo "Dotfiles repository already cloned."
  fi

  cd -P /home/$USER/dotfiles

  step "Copying config files..."
  cp -r nvim wlogout waybar wal zsh rofi swaync kitty hypr fastfetch lf cptv /home/$USER/.config/
  cp starship.toml /home/$USER/.config/
  cp .markdownlint-cli2.yaml /home/$USER/
  cp .zshrc /home/$USER/
  cp .tmux.conf /home/$USER/

  cd -P /home/$USER
}

setup_collabora() {
  step "Setting up Collabora Online and Core..."

  step "Installing Collabora dependencies..."
  yay -S --noconfirm --needed 'base-devel' 'git' 'ccache' 'ant' 'apr' 'beanshell' 'bluez-libs' 'clucene' \
    'coin-or-mp' 'cppunit' 'curl' 'dbus-glib' \
    'desktop-file-utils' 'doxygen' 'flex' 'gcc-libs' \
    'gdb' 'glm' 'gobject-introspection' 'gperf' 'gpgme' \
    'graphite' 'gst-plugins-base-libs' 'gtk3' \
    'harfbuzz-icu' 'hicolor-icon-theme' 'hunspell' \
    'hyphen' 'icu' 'java-environment' 'junit' \
    'lcms2' 'libabw' 'libatomic_ops' 'libcdr' 'libcmis' \
    'libe-book' 'libepoxy' 'libepubgen' 'libetonyek' \
    'libexttextcat' 'libfreehand' 'libgl' 'libjpeg' \
    'liblangtag' 'libmspub' 'libmwaw' 'libmythes' \
    'libnumbertext' 'libodfgen' 'liborcus' 'libpagemaker' \
    'libqxp' 'libstaroffice' 'libtommath' 'libvisio' \
    'libwpd' 'libwpg' 'libwps' 'libxinerama' 'libxrandr' \
    'libxslt' 'libzmf' 'lpsolve' 'mariadb-libs' \
    'mdds' 'nasm' 'neon' 'nspr' 'nss' 'pango' \
    'plasma-framework5' 'poppler' 'postgresql-libs' \
    'python' 'qt5-base' 'redland' 'sane' 'serf' 'sh' \
    'shared-mime-info' 'ttf-liberation' 'unixodbc' \
    'unzip' 'xmlsec' 'zip' 'gtk4' 'qt6-base' 'zxing-cpp' \
    'abseil-cpp' 'meson'

  yay -S --noconfirm --needed libcap libcap-ng lib32-libcap libpng poco \
    cppunit nodejs npm chromium python-lxml python-polib

  COLLABORA_DIR="/home/$USER/collabora"
  mkdir -p "$COLLABORA_DIR/online"
  mkdir -p "$COLLABORA_DIR/core"

  step "Cloning and building LibreOffice core..."
  if [ ! -d "$COLLABORA_DIR/core/co-2504" ]; then
    cd -P "$COLLABORA_DIR/core"
    git clone https://gerrit.libreoffice.org/core co-2504
    cd -P co-2504
    git checkout distro/collabora/co-25.04
    ./autogen.sh --enable-dbgutil --without-system-nss --without-junit
    make PARALLELISM=$(nproc)
  else
    echo "LibreOffice core already cloned and built."
  fi

  step "Cloning and building Collabora Online..."
  if [ ! -d "$COLLABORA_DIR/online/master" ]; then
    cd -P "$COLLABORA_DIR/online"
    git clone https://github.com/CollaboraOnline/online master
    cd -P master
    ./autogen.sh
    ./configure --enable-silent-rules --with-lokit-path=${COLLABORA_DIR}/core/co-2504/include \
      --with-lo-path=${COLLABORA_DIR}/core/co-2504/instdir \
      --enable-debug --enable-cypress --enable-feature-lock
    make -j$(nproc)
  else
    echo "Collabora Online already cloned and built."
  fi
}

# --- Main Function ---
main() {
  step "Starting Arch Linux setup..."

  install_yay
  install_packages
  install_fonts
  enable_services
  copy_dotfiles

  read -p "Do you want to install Collabora Online and Core? (y/N) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    setup_collabora
  fi

  step "Setup complete! Please reboot your system."
}

main
