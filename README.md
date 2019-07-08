# Workspace configs

1) [Atom](./atom/)

2) [Zsh](./zsh)

- choose the appropriate zsh file (zshrc_mac for macosx zshrc for linux)
- clone `oh-my-zsh` into ~/.oh-my-zsh `mkdir ~/.oh-my-zsh && cd ~/.oh-my-zsh && git clone https://github.com/robbyrussell/oh-my-zsh`

- install powerlevel10k zsh theme `git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k && echo 'source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme' >>! ~/.zshrc
`

- download meslo nerd font complete from `https://github.com/ryanoasis/nerd-fonts/blob/e9ec3ae4548e59eb9a6531f38370cb99ca591e16/patched-fonts/Meslo/L-DZ/complete/`

- and install the font
```
mv /path/to/font.otf /usr/local/share/fonts/opentype
dpkg-reconfigure fontconfig-config # don't make any changes
fc-list # verifies installation
```
(finally, set the tilix font in your profile to Meslo)

- download plugins
- `git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions`
```
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
echo "source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
```

3) [i3 window manager](./i3)

## Setup

1) Create a hardlink between the `aliases` file and `~/.aliases` with `ln aliases ~/.aliases`
2) Repeat with the appropriate zsh file `ln zshrc ~/.zshrc`
3) (linux) hardlink compton.conf `ln .compton.conf ~/.compton.conf`
4) (linux) install "xfce4-power-manager" `apt-get install xfce4-power-manager`
5) (linux) use feh for rotating wallpaper `apt-get install feh` with pictures in folder `~/Pictures/wallpapers` and hardlink `ln fehbg-rotate ~/.fehbg-rotate && chmod 777 ~/.fehbg-rotate`
