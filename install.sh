#!/usr/bin/env bash
#
#
CRE=$(tput setaf 1)
CYE=$(tput setaf 3)
CGR=$(tput setaf 2)
CBL=$(tput setaf 4)
BLD=$(tput bold)
CNC=$(tput sgr0)

if [ "$(id -u)" = 0 ]; then
    echo "This script MUST NOT be run as root user."
    exit 1
fi

#Pacman dependences
dependences = (alacritty feh pavucontrol lightdm lightdm-gtk-greeter \
  redshift xclip neovim gawk grep zip unzip \
  pipewire pipewire-alsa pipewire-audio pipewire-jack pipewire-pulse \
  wireplumber sxhkd bspwm polybar net-tools lxsession \
  brightnessctl xorg-xsetroot pidof picom nodejs npm \
  rofi procps-ng ttf-iosevka-nerd ttf-jetbrains-mono-nerd ttf-liberation \
  ttf-liberation-mono-nerd ttf-nerd-fonts-symbols papirus-icon-theme pamixer \
  zsh zsh-autosuggestions zsh-completions zsh-history-substring-search \
  zsh-lovers zsh-syntax-highlighting zsh-theme-powerlevel10k xorg-xset)

is_installed() {
  pacman -Qi "$1" & > /dev/null
  return $?
}

printf "%s%sChecking for required packages...%s\n"

for package in "$dependences[@]"; do
  if ! is_installed "$package"; then
    if sudo pacman -S "$package" --noconfirm > /dev/null 2>> errors.log; then
      printf "%s%s%s %shas been installed succesfully.%s\n" "${BLD}" "${CYE}" "$package" "${CBL}" "${CNC}"
      sleep 1
    else
      printf "%s%s%s %shas not been installed correctly. See %serrors.log %sfor more details.%s\n" "${BLD}" "${CYE}" "$package"
      sleep 1
    fi
  else
    printf '%s%s%s %sis already installed on your system!%s\n' "${BLD}" "${CYE}" "$package" "${CGR}" "${CNC}"
    sleep 1
  fi
done
sleep 5
clear

if [ ! -e "$HOME/.config" ]; then
  mkdir $HOME/.config
  echo "Se creo el directorio .config"
else
  echo "El directorio .config existe"
fi


cp -rf $HOME/mybspwm/config/* $HOME/.config/
cp $HOME/mybspwm/home/* $HOME/

echo "Copiando archivos a root"

sudo mkdir /root/.config

sudo cp -rf $HOME/mybspwm/config/zsh /root/.config/
sudo ln -s $HOME/.p10k.zsh /root/.p10k.zsh
sudo ln -s $HOME/.zshrc /root/.zshrc

echo "Instalando zsh"
if [[ $SHELL != "/usr/bin/zsh" ]]; then
    printf "\n%s%sChanging your shell to zsh. Your root password is needed.%s\n\n" "${BLD}" "${CYE}" "${CNC}"
    chsh -s /usr/bin/zsh
    sudo chsh -s /usr/bin/zsh
    printf "%s%sShell changed to zsh. Please reboot.%s\n\n" "${BLD}" "${CGR}" "${CNC}"
else
    printf "%s%sYour shell is already zsh\nGood bye! installation finished, now reboot%s\n" "${BLD}" "${CGR}" "${CNC}"
fi



