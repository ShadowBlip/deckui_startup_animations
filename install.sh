#!/usr/bin/env bash

# Create required directories
echo ":: Creating required directories"
mkdir -p "$HOME/homebrew"
mkdir -p "$HOME/.config/systemd/user"

# Clone the startup animations repository
if [[ ! -d "$HOME/homebrew/startup_animations" ]]; then
  echo ":: Installing to $HOME/homebrew/startup_animations"
  git clone https://github.com/ShadowBlip/deckui_startup_animations "$HOME/homebrew/startup_animations"
  cd "$HOME/homebrew/startup_animations"
else
  echo ":: Updating $HOME/homebrew/startup_animations"
  cd "$HOME/homebrew/startup_animations"
  git pull
fi

# Install the service file
echo ":: Installing the startup service"

echo "
[Unit]
Description=Randomize deck_startup.webm after boot

[Install]
WantedBy=default.target

[Service]
Type=oneshot
WorkingDirectory=${HOME}/homebrew/startup_animations
# ExecStartPre=/bin/sleep 30
ExecStart=${HOME}/homebrew/startup_animations/deckui_animations.sh
" > "$HOME/.config/systemd/user/deckui_animations"
systemctl --user daemon-reload
systemctl --user enable --now deckui_animations.service

