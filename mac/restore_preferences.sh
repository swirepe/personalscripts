#!/usr/bin/env bash
mv ~/Library/Preferences ~/Library/Preferences-$(date +"%Y-%m-%d")
mkdir ~/Library/Preferences
tar xvf ~/pers/scripts/mac/preferences.tar.gz -C ~/Library/Preferences

