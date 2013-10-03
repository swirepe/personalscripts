#!/usr/bin/env bash

mv ~/Library/Services ~/Library/Services-$(date +"%Y-%m-%d")
mkdir ~/Library/Services
tar xvf ~/pers/scripts/mac/services.tar.gz -C ~/Library/Services
