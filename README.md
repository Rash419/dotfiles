# Arch Linux Setup Script

This script automates the setup of a complete Arch Linux desktop environment based on Hyprland. It installs necessary packages, fonts, development tools, and configures the system using the dotfiles from this repository.

## Prerequisites

- A base Arch Linux installation.
- An active internet connection.
- A user with `sudo` privileges.
- `git` installed (`sudo pacman -S git`).

## How to Use

1. **Clone the repository:**

   ```bash
   git clone https://github.com/Rash419/dotfiles.git
   cd dotfiles
   ```

2. **Run the setup script:**
   The script is located in the `scripts/` directory. Make it executable and run it.

   ```bash
   chmod +x scripts/arch_setup.sh
   ./scripts/arch_setup.sh
   ```

3. **Follow the prompts:**
   The script will ask for your password for `sudo` commands. It will also ask if you want to perform the lengthy installation for the Collabora Online development environment.

4. **Reboot:**
   After the script finishes, reboot your system for all changes to take effect.

   ```bash
   sudo reboot
   ```

## What the Script Does

### 1. AUR Helper

- Installs `yay`, a popular AUR helper, to manage packages from both the official repositories and the Arch User Repository (AUR).

### 2. Package Installation

The script installs a comprehensive set of packages, including:

- **Desktop Environment:** `hyprland`, `sddm`, `waybar`, `swaync`, `wlogout`, `hyprlock`.
- **Terminal & Shell:** `kitty`, `zsh`, `starship`, `fzf`.
- **CLI Tools:** `lsd`, `zoxide`, `fastfetch`, `neovim`, `pywal`, `cliphist`, `tmux`, `lazygit`.
- **Utilities:** `brightnessctl`, `wifi-menu`, `bluetui`, `wf-recorder`, `hyprshot`.
- **Development:** `npm`, `openssh`, `tailscale`, `jdk11-openjdk`, `helm`, `kubectl`, `github-cli`, `minikube`, `docker`.

### 3. Font Installation

Installs a collection of fonts required for the configured look and feel:

- `Nothingfont`
- `DepartureMono`
- `ttf-jetbrains-mono-nerd`
- `noto-fonts-emoji`

It also rebuilds the font cache (`fc-cache`).

### 4. System Services

Enables the following essential systemd services to start on boot:

- `sddm.service` (Display Manager)
- `bluetooth.service` (Bluetooth)
- `docker.service` (Docker Daemon)
- `hyprpolkitagent.service` (Polkit agent for Hyprland)

### 5. Dotfiles Configuration

- Clones the [dotfiles repository](https://github.com/Rash419/dotfiles) to your home directory if it doesn't already exist.
- Copies the configuration files for all the installed applications (`nvim`, `hypr`, `kitty`, `rofi`, `waybar`, etc.) into the `~/.config` directory.
- Places `.zshrc` and `.tmux.conf` in the home directory.

### 6. Optional: Collabora Online Setup

- The script provides an optional step to set up a full development environment for **Collabora Online**.
- This is a lengthy process that involves cloning and building both the LibreOffice core and Collabora Online from source.
- It installs a large number of development dependencies required for the build.
- **Note:** Only select 'yes' for this step if you are a Collabora developer or specifically need this environment, as it is resource and time-intensive.

## Customization

You can customize the script by editing `scripts/arch_setup.sh` before running it.

- **Packages:** Add or remove packages from the `yay -S ...` lines in the `install_packages` function.
- **Fonts:** Modify the `install_fonts` function to add or remove fonts.
- **Dotfiles:** The script is hardcoded to use the dotfiles from this repository. Fork the repository and change the `git clone` URL in the `copy_dotfiles` function to use your own version.
