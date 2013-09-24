
# display most recent gmail if we can
if [[ -e ~/.bashrc_gmail                ]] &&
   [[ ! -e ~/.hushlogin                 ]] &&
   [ ping -c 1 google.com &> /dev/null   ]
then
	if [[ -e ~/.mre.config ]]
	then
		echo -e "${COLOR_Green}Most recent email:${COLOR_off}"
		mre
	else
		echo -e "${COLOR_Blue}Setting up mre for email access.${COLOR_off}"
		. $SCRIPTS_DIR/rc/setup-mre.sh
	fi
fi
