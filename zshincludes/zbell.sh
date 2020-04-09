#!/usr/bin/env zsh
## https://gist.github.com/jpouellet/5278239
## http://blog.patshead.com/2014/01/getting-notified-when-long-running-zsh-processes-complete.html
## http://blog.patshead.com/2014/02/a-couple-of-zbell-dot-zsh-bug-fixes.html
## https://gist.github.com/oknowton/8346801
##
# This script prints a bell character when a command finishes
# if it has been running for longer than $zbell_short_duration seconds.
# If there are programs that you know run long that you don't
# want to bell after, then add them to $zbell_ignore.
#
# This script uses only zsh builtins so its fast, there's no needless
# forking, and its only dependency is zsh and its standard modules
#
# Written by Jean-Philippe Ouellet <jpo@vt.edu>
# Made available under the ISC license.

# only do this if we're in an interactive shell
[[ -o interactive ]] || return

# get $EPOCHSECONDS. builtins are faster than date(1)
zmodload zsh/datetime || return

# make sure we can register hooks
autoload -Uz add-zsh-hook || return

# initialize zbell_short_duration if not set (15 seconds)
(( ${+zbell_short_duration} )) || zbell_short_duration=15

# initialize zbell_long_duration if not set (3 minutes)
(( ${+zbell_long_duration} )) || zbell_long_duration=180


# initialize zbell_ignore if not set
(( ${+zbell_ignore} )) || zbell_ignore=($EDITOR $PAGER ls watch htop top ssh iotop dstat vmstat nano emacs vi bwm-ng less more fdisk audacious play aplay sqlite3 wine mtr ping traceroute vlc mplayer smplayer tail tmux screen man sawfish-config powertop g glances w3m vim eclipse newscript aria2c eclipse ipython R mit-scheme bash zsh viewsh psql eog ranger docker slay_the_spire.sh kismet)
 
zbell_email() {
curl --ssl-reqd \
  --url "smtps://mail.swirepe.com:465" \
  --mail-from "notifier@swirepe.com" \
  --mail-rcpt "notifier@swirepe.com" \
  --user 'notifier@swirepe.com:discriminating-7391-splinters' \
  --insecure --upload-file - &> /dev/null <<EOF &|
From: "ZSH Notification" <notifier@swirepe.com>
To: "Peter S <notifier@swirepe.com>"
Subject: $HOST - $zbell_lastcmd

Completed with exit status $zbell_exit_status


Love,

Zbell

EOF
}

set_lamp() {
 	if [[ -e /sys/class/leds/tpacpi::thinklight/brightness ]]; then
		echo $1 | sudo tee /sys/class/leds/tpacpi::thinklight/brightness > /dev/null
  fi
}

zbell_blink() {
	if [[ -e /sys/class/leds/tpacpi::thinklight/brightness ]]; then
		CYCLES=3
		CYCLE_DURATION=1.2
		BLINKS=3
		ON_DURATION=0.3
		OFF_DURATION=0.3
		for _ in $(seq 1 $CYCLES)
		do 
			for _ in $(seq 1 $BLINKS)
			do
				set_lamp 255
				sleep $ON_DURATION
				set_lamp 0
				sleep $OFF_DURATION
			done
			sleep $CYCLE_DURATION
		done
	fi
}


# initialize it because otherwise we compare a date and an empty string
# the first time we see the prompt. it's fine to have lastcmd empty on the
# initial run because it evaluates to an empty string, and splitting an
# empty string just results in an empty array.
zbell_timestamp=$EPOCHSECONDS

# right before we begin to execute something, store the time it started at
zbell_begin() {
  zbell_timestamp=$EPOCHSECONDS
  zbell_lastcmd=$1
}

# when it finishes, if it's been running longer than $zbell_short_duration,
# and we dont have an ignored command in the line, then print a bell.
zbell_end() {
  zbell_exit_status=$?
  ran_short=$(( $EPOCHSECONDS - $zbell_timestamp >= $zbell_short_duration ))
  ran_long=$(( $EPOCHSECONDS - $zbell_timestamp >= $zbell_long_duration ))
  has_ignored_cmd=0
  for cmd in ${(s:;:)zbell_lastcmd//|/;}; do
    words=(${(z)cmd})
    util=${words[1]}
    if (( ${zbell_ignore[(i)$util]} <= ${#zbell_ignore} )); then
      has_ignored_cmd=1
      break
    fi
  done

  if (( ! $has_ignored_cmd )) && (( ran_short )); then
    print -n "\a"
    which notify-send &> /dev/null && notify-send "$zbell_lastcmd"
  fi
  
  if (( ! $has_ignored_cmd )) && (( ran_long )); then
    zbell_email
		zbell_blink
  fi
}


# register the functions as hooks
add-zsh-hook preexec zbell_begin
add-zsh-hook precmd zbell_end
