## https://wiki.archlinux.org/index.php/Color_Bash_Prompt

# Reset
export COLOR_off='\033[0m'       # Text Reset

# if you forget to close some colors, it will mess with the way text wraps
export COLOR_REALLY_OFF="$COLOR_off$COLOR_off$COLOR_off$COLOR_off$COLOR_off$COLOR_off$COLOR_off$COLOR_off$COLOR_off$COLOR_off$COLOR_off$COLOR_off"

# Regular Colors
export COLOR_Black='\033[0;30m'        # Black
export COLOR_Red='\033[0;31m'          # Red
export COLOR_Green='\033[0;32m'        # Green
export COLOR_Yellow='\033[0;33m'       # Yellow
export COLOR_Blue='\033[0;34m'         # Blue
export COLOR_Purple='\033[0;35m'       # Purple
export COLOR_Cyan='\033[0;36m'         # Cyan
export COLOR_White='\033[0;37m'        # White


# Bold
export COLOR_BBlack='\033[1;30m'       # Black
export COLOR_BRed='\033[1;31m'         # Red
export COLOR_BGreen='\033[1;32m'       # Green
export COLOR_BYellow='\033[1;33m'      # Yellow
export COLOR_BBlue='\033[1;34m'        # Blue
export COLOR_BPurple='\033[1;35m'      # Purple
export COLOR_BCyan='\033[1;36m'        # Cyan
export COLOR_BWhite='\033[1;37m'       # White

# Underline
export COLOR_UBlack='\033[4;30m'       # Black
export COLOR_URed='\033[4;31m'         # Red
export COLOR_UGreen='\033[4;32m'       # Green
export COLOR_UYellow='\033[4;33m'      # Yellow
export COLOR_UBlue='\033[4;34m'        # Blue
export COLOR_UPurple='\033[4;35m'      # Purple
export COLOR_UCyan='\033[4;36m'        # Cyan
export COLOR_UWhite='\033[4;37m'       # White

# Background
export COLOR_On_Black='\033[40m'       # Black
export COLOR_On_Red='\033[41m'         # Red
export COLOR_On_Green='\033[42m'       # Green
export COLOR_On_Yellow='\033[43m'      # Yellow
export COLOR_On_Blue='\033[44m'        # Blue
export COLOR_On_Purple='\033[45m'      # Purple
export COLOR_On_Cyan='\033[46m'        # Cyan
export COLOR_On_White='\033[47m'       # White

# High Intensity
export COLOR_IBlack='\033[0;90m'       # Black
export COLOR_IRed='\033[0;91m'         # Red
export COLOR_IGreen='\033[0;92m'       # Green
export COLOR_IYellow='\033[0;93m'      # Yellow
export COLOR_IBlue='\033[0;94m'        # Blue
export COLOR_IPurple='\033[0;95m'      # Purple
export COLOR_ICyan='\033[0;96m'        # Cyan
export COLOR_IWhite='\033[0;97m'       # White

# Bold High Intensity
export COLOR_BIBlack='\033[1;90m'      # Black
export COLOR_BIRed='\033[1;91m'        # Red
export COLOR_BIGreen='\033[1;92m'      # Green
export COLOR_BIYellow='\033[1;93m'     # Yellow
export COLOR_BIBlue='\033[1;94m'       # Blue
export COLOR_BIPurple='\033[1;95m'     # Purple
export COLOR_BICyan='\033[1;96m'       # Cyan
export COLOR_BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
export COLOR_On_IBlack='\033[0;100m'   # Black
export COLOR_On_IRed='\033[0;101m'     # Red
export COLOR_On_IGreen='\033[0;102m'   # Green
export COLOR_On_IYellow='\033[0;103m'  # Yellow
export COLOR_On_IBlue='\033[0;104m'    # Blue
export COLOR_On_IPurple='\033[10;95m'  # Purple
export COLOR_On_ICyan='\033[0;106m'    # Cyan
export COLOR_On_IWhite='\033[0;107m'   # White


## http://www.commandlinefu.com/commands/view/5879/show-numerical-values-for-each-of-the-256-colors-in-bash
alias show_colors_cols='for i in {0..255}; do echo -e "\033[38;05;${i}m${i}"; done | column -c 80 -s "  " ; echo -e "\033[m"'

function show_colors {
    for code in {0..255}; do show_color $code ; done
}

function show_color {
    echo -e "\033[38;05;${1}m $1: Test"
    color_off
}


function color {
    echo -en "\033[38;05;${1}m${1}"
}

function color_off {
    echo -en "$COLOR_off"
}
