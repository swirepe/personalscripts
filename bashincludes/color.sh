## https://wiki.archlinux.org/index.php/Color_Bash_Prompt

# Reset
export COLOR_off='\e[0m'       # Text Reset

# if you forget to close some colors, it will mess with the way text wraps
export COLOR_REALLY_OFF="$COLOR_off$COLOR_off$COLOR_off$COLOR_off$COLOR_off$COLOR_off$COLOR_off$COLOR_off$COLOR_off$COLOR_off$COLOR_off$COLOR_off"

# Regular Colors
export COLOR_Black='\e[0;30m'        # Black
export COLOR_Red='\e[0;31m'          # Red
export COLOR_Green='\e[0;32m'        # Green
export COLOR_Yellow='\e[0;33m'       # Yellow
export COLOR_Blue='\e[0;34m'         # Blue
export COLOR_Purple='\e[0;35m'       # Purple
export COLOR_Cyan='\e[0;36m'         # Cyan
export COLOR_White='\e[0;37m'        # White


# Bold
export COLOR_BBlack='\e[1;30m'       # Black
export COLOR_BRed='\e[1;31m'         # Red
export COLOR_BGreen='\e[1;32m'       # Green
export COLOR_BYellow='\e[1;33m'      # Yellow
export COLOR_BBlue='\e[1;34m'        # Blue
export COLOR_BPurple='\e[1;35m'      # Purple
export COLOR_BCyan='\e[1;36m'        # Cyan
export COLOR_BWhite='\e[1;37m'       # White

# Underline
export COLOR_UBlack='\e[4;30m'       # Black
export COLOR_URed='\e[4;31m'         # Red
export COLOR_UGreen='\e[4;32m'       # Green
export COLOR_UYellow='\e[4;33m'      # Yellow
export COLOR_UBlue='\e[4;34m'        # Blue
export COLOR_UPurple='\e[4;35m'      # Purple
export COLOR_UCyan='\e[4;36m'        # Cyan
export COLOR_UWhite='\e[4;37m'       # White

# Background
export COLOR_On_Black='\e[40m'       # Black
export COLOR_On_Red='\e[41m'         # Red
export COLOR_On_Green='\e[42m'       # Green
export COLOR_On_Yellow='\e[43m'      # Yellow
export COLOR_On_Blue='\e[44m'        # Blue
export COLOR_On_Purple='\e[45m'      # Purple
export COLOR_On_Cyan='\e[46m'        # Cyan
export COLOR_On_White='\e[47m'       # White

# High Intensity
export COLOR_IBlack='\e[0;90m'       # Black
export COLOR_IRed='\e[0;91m'         # Red
export COLOR_IGreen='\e[0;92m'       # Green
export COLOR_IYellow='\e[0;93m'      # Yellow
export COLOR_IBlue='\e[0;94m'        # Blue
export COLOR_IPurple='\e[0;95m'      # Purple
export COLOR_ICyan='\e[0;96m'        # Cyan
export COLOR_IWhite='\e[0;97m'       # White

# Bold High Intensity
export COLOR_BIBlack='\e[1;90m'      # Black
export COLOR_BIRed='\e[1;91m'        # Red
export COLOR_BIGreen='\e[1;92m'      # Green
export COLOR_BIYellow='\e[1;93m'     # Yellow
export COLOR_BIBlue='\e[1;94m'       # Blue
export COLOR_BIPurple='\e[1;95m'     # Purple
export COLOR_BICyan='\e[1;96m'       # Cyan
export COLOR_BIWhite='\e[1;97m'      # White

# High Intensity backgrounds
export COLOR_On_IBlack='\e[0;100m'   # Black
export COLOR_On_IRed='\e[0;101m'     # Red
export COLOR_On_IGreen='\e[0;102m'   # Green
export COLOR_On_IYellow='\e[0;103m'  # Yellow
export COLOR_On_IBlue='\e[0;104m'    # Blue
export COLOR_On_IPurple='\e[10;95m'  # Purple
export COLOR_On_ICyan='\e[0;106m'    # Cyan
export COLOR_On_IWhite='\e[0;107m'   # White


## http://www.commandlinefu.com/commands/view/5879/show-numerical-values-for-each-of-the-256-colors-in-bash
alias show_colors_cols='for i in {0..255}; do echo -e "\e[38;05;${i}m${i}"; done | column -c 80 -s "  " ; echo -e "\e[m"'

function show_colors {
    for code in {0..255}; do show_color $code ; done
}

function show_color {
    echo -e "\e[38;05;${1}m $1: Test"
    color_off
}


function color {
    echo -en "\e[38;05;${1}m${1}"
}

function color_off {
    echo -en "$COLOR_off"
}
