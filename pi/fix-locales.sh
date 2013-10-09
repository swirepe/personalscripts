#!/usr/bin/env bash
# http://www.thomas-krenn.com/de/wiki/Perl_warning_Setting_locale_failed_unter_Debian

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
sudo locale-gen en_US.UTF-8
sudo dpkg-reconfigure locales
