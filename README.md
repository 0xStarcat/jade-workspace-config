# Workspace configs

## Helpful things to install first

1. Snap `sudo apt-get install snapd`
2. LinuxBrew https://brew.sh/ `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
3. pyenv (python version manager), nvm (node version manager) `brew install pyenv && brew install nvm`
4. rbenv https://github.com/rbenv/rbenv `brew install rbenv`
5. npm & yarn `brew install npm && brew install yarn`
6. docker

```
sudo addgroup --system docker
sudo adduser $USER docker
newgrp docker
sudo snap install docker
```

7. compton, xss-lock, feh-bg, xfce4-power-manager, xautolock, dconf-editor

## Generate a new RSA public key

1. add it to github
2. add it to digital ocean or any other hosting where u ssh

## Tilix https://gnunn1.github.io/tilix-web/

```
sudo apt-get install tilix
```

- to dump the tilix config to a file, run: `dconf dump /com/gexperts/Tilix/ > tilix.dconf`

## [VSCode](./vscode/)

## [Zsh](./zsh)

- choose the appropriate zsh file (zshrc_mac for macosx zshrc for lizshnux)
- clone `oh-my-zsh` into ~/.oh-my-zsh `mkdir ~/.oh-my-zsh && cd ~/.oh-my-zsh && git clone https://github.com/robbyrussell/oh-my-zsh`

- install powerlevel10k zsh theme `git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k && echo 'source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme' >>! ~/.zshrc`

- download meslo nerd font complete from `https://github.com/ryanoasis/nerd-fonts/blob/e9ec3ae4548e59eb9a6531f38370cb99ca591e16/patched-fonts/Meslo/L-DZ/complete/`

- and install the font

```
mv /path/to/font.otf /usr/local/share/fonts/opentype
dpkg-reconfigure fontconfig-config # don't make any changes
fc-list # verifies installation
```

(finally, set the tilix font in your profile to Meslo)

- download plugins

```
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
```

```
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
echo "source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
```

- add command to tilix to start zsh on new shell in Preferences > Profile (defualt) > Command `zsh`

## [i3 window manager](./i3)

### Setup

- Setup the i3 WM to load on login at (if using debian w/ gdm3) the login screen by clicking on the cog (settings icon) before login and selecting "i3"

1. Create a hardlink between the `aliases` file and `~/.aliases` with `ln aliases ~/.aliases`
2. Repeat with the appropriate zsh file `ln zshrc ~/.zshrc`
3. (linux) hardlink compton.conf `ln .compton.conf ~/.compton.conf`
4. (linux) add tilix config back in `dconf load /com/gexperts/Tilix/ < tilix.dconf`
5. (linux) install "xfce4-power-manager" `apt-get install xfce4-power-manager`
6. (linux) install light-locker `apt-get install light-locker` # changes login screen
7. (linux) use feh for rotating wallpaper `apt-get install feh` with pictures in folder `~/Pictures/wallpapers` and hardlink `ln fehbg-rotate ~/.fehbg-rotate && chmod 777 ~/.fehbg-rotate`
<!-- 8. (linux) add `00_refresh_screen_on_thaw` script to `/etc/pm/sleep.d` -->
8. copy over `~/.xinitrc`
9. if backlight keys don't work, check if u have "intel_backlight" `ls /sys/class/backlight`. if you do, copy the xorg.conf file into `/etc/X11/xorg.conf`

## Configure lock screen / suspend / power management

https://bbs.archlinux.org/viewtopic.php?id=208875
https://askubuntu.com/questions/1009387/laptop-doesnt-suspend-properly-on-closing-lid

1. add a lock screen `.png` to `~/Pictures/lock-screen.png`
2. move `i3exit` to `/usr/local/bin/i3exit` and configure the path to the lock screen
3. configure with xfcd4-power-manager `xfce4-power-manager -c`

## configure trackpad

https://cravencode.com/post/essentials/enable-tap-to-click-in-i3wm/

- makes 2-finger clicks into right clicks

edit `/etc/X11/xorg.conf.d/90-touchpad.conf`

```
Section "InputClass"
        Identifier "touchpad"
        MatchIsTouchpad "on"
        Driver "libinput"
        # Option "Tapping" "on" # tap to click
	      Option "ClickMethod" "clickfinger" # click anywhere you want
        Option "TapButton1" "1"
        Option "TapButton2" "2"
        Option "TapButton3" "3"
        Option "ClickFinger1" "1"
        Option "ClickFinger2" "2"
        Option "ClickFinger3" "3"

EndSection

```

## Fixing headphones and audio

LINUX AUDIO IS SO BAD AND EVERYONE IS SO UNHELPFUL. For now, run this command every time you restart: `alsactl restore`. use `alsamixer` if sound is coming out of both your headphones and speakers to mute one.

https://askubuntu.com/questions/132440/headphone-jack-not-working

```
alsactl restore
```

## Setup Dropbox

https://www.linuxbabe.com/ubuntu/install-dropbox-headless-ubuntu-server

1. wget "https://www.dropbox.com/download?plat=lnx.x86_64" -O dropbox-linux.tar.gz
2. sudo mkdir /opt/dropbox/
3. sudo tar xvf dropbox-linux.tar.gz --strip 1 -C /opt/dropbox
4. sudo apt install libc6 libglapi-mesa libxdamage1 libxfixes3 libxcb-glx0 libxcb-dri2-0 libxcb-dri3-0 libxcb-present0 libxcb-sync1 libxshmfence1 libxxf86vm1
5. /opt/dropbox/dropboxd
6. sudo nano /etc/systemd/system/dropbox.service

```
[Unit]
Description=Dropbox Daemon
After=network.target

[Service]
Type=simple
User=lola
ExecStart=/opt/dropbox/dropboxd
ExecStop=/bin/kill -HUP $MAINPID
Restart=always

[Install]
WantedBy=multi-user.target
```

7. sudo systemctl start dropbox
8. sudo systemctl enable dropbox

## Backup / Restoring

https://www.linux.com/learn/full-metal-backup-using-dd-command

1. Backup to .tar file

```
# can take about an hour
# canceling in the middle with ctrl+c is fine.
sudo dd if=/dev/sda conv=sync,noerror bs=64K status=progress | gzip -c  > angel_backup.img.gz

```

2. Move the image into a separate device (portable harddrive, cloud storage, etc)

3. Restore by booting in recovery mode into a root terminal and running:

```
# mount disk first
mount /dev/sdb /mnt
gunzip -c /PATH/TO/DRIVE/backup_image.img.gz | dd of=/dev/sda status=progress

```
