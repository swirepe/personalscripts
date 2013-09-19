#!/usr/bin/env bash

# this script tries to set a motd based on the hostname.
# if that fails, it chooses a random one.
# ascii art taken from http://www.geocities.com/spunk1111/aquatic.htm#lobster
# gradients made with scripts/seagradients.py

COLOR_BIGreen="\033[1;92m"
COLOR_off="\033[0m"

function betta {
                   
echo -e "\033[0;95m                                   __,                      "
echo -e "\033[0;35m                                .-'_-'\`                     "
echo -e "\033[0;34m                              .' {\`                         "
echo -e "\033[0;94m                          .-'\`\`\`\`'-.    .-'\`\`'.             "
echo -e "\033[0;96m                        .'(0)       '._/ _.-.  \`\           "
echo -e "\033[0;95m                       }     '. ))    _<\`    )\`  |          "
echo -e "\033[0;35m                        \`-.,\'.\_,.-\\` \\`---; .' /          "
echo -e "\033[0;34m                             )  )       '-.  '--:           "
echo -e "\033[0;94m                            ( ' (          ) '.  \          "
echo -e "\033[0;96m                             '.  )      .'(   /   )         "
echo -e "\033[0;95m                               )/      (   '.    /          "
echo -e "\033[0;35m                                        '._( ) .'           "
echo -e "\033[0;34m                                            ( (             "
echo -e "\033[0;94m                                             \`-.            "
                                             
                            
}                       

function smokeshark {
    

echo -e "\033[0;95m                                                           ,  "
echo -e "\033[0;35m                                   |  \`'.                     "
echo -e "\033[0;34m                __           |\`-._/_.:---\`-.._             )  "
echo -e "\033[0;94m                \='.       _/..--'\`__         \`'-._|      (   "
echo -e "\033[0;96m                 \- '-.--\"\`      ===    ----/--(O)-|',     )  "
echo -e "\033[0;95m                  )= (                  --_ |       _.'   (   "
echo -e "\033[0;35m                 /_=.'-._             {=_-_ |   .--\`-.====*   "
echo -e "\033[0;34m                /_.'    \`\\''-._        '-=   \ \\\\.'         "
echo -e "\033[0;94m                         )  _.-'\`'-..       _..-\\\\          "
echo -e "\033[0;96m                        /_.'        \`/\";';\`|                  "
echo -e "\033[0;95m                                      \` .'/                   "
echo -e "\033[0;35m                                      '--'                    "
echo -e "\033[0;34m                                                              "


}                      

function octopus {

echo -e "\033[0;94m                                   ___                                    "
echo -e "\033[0;96m                                .-'   \`'.                                 "
echo -e "\033[0;95m                               /         \                                "
echo -e "\033[0;35m                               |         ;                                "
echo -e "\033[0;34m                               |         |           ___.--,              "
echo -e "\033[0;94m                      _.._     |0) ~ (0) |    _.---'\`__.-( (_.            "
echo -e "\033[0;96m               __.--'\`_.. '.__.\    '--. \_.-' ,.--'\`     \`\"\"\`          "
echo -e "\033[0;95m              ( ,.--'\`   ',__ /./;   ;, '.__.'\`    __                     "
echo -e "\033[0;35m              _\`) )  .---.__.' / |   |\   \__..--\"\"  \"\"\"--.,_        "
echo -e "\033[0;34m             \`---' .'.''-._.-'\`_./  /\ '.  \ _.-~~~\`\`\`\`~~~-._\`-.__.'      "
echo -e "\033[0;94m                   | |  .' _.-' |  |  \  \  '.               \`~---\`       "
echo -e "\033[0;96m                    \ \/ .'     \  \   '. '-._)                           "
echo -e "\033[0;95m                     \/ /        \  \    \`=.__\`~-.                        "
echo -e "\033[0;35m                     / /\         \`) )    / / \`\"\".\`\                    "
echo -e "\033[0;34m               , _.-'.'\ \        / /    ( (     / /                      "
echo -e "\033[0;94m                \`--~\`   ) )    .-'.'      '.'.  | (                       "
echo -e "\033[0;94m                       (/\`    ( (\`          ) )  '-;                      "
echo -e "\033[0;96m                        \`      '-;         (-'                            "
echo -e "\033[0;95m                                                                          "
                                                                                           
    
}

function seahorse {

                                                                              
echo -e "\033[0;35m                                    \:.|\`._                  "
echo -e "\033[0;34m                                 /\/;.:':::;;;._             "
echo -e "\033[0;94m                                <  .'     ':::;(             "
echo -e "\033[0;96m                                 < ' _      '::;>            "
echo -e "\033[0;95m                                  \ (9)  _  :::;(            "
echo -e "\033[0;35m                                  |     / \   ::;\`>          "
echo -e "\033[0;34m                                  |    /  |    :;(           "
echo -e "\033[0;94m                                  |   (  <=-  .::;>          "
echo -e "\033[0;96m                                  (  a) )=-  .::;(           "
echo -e "\033[0;95m                                   '-' <=-  .::;>            "
echo -e "\033[0;35m                                      )==- ::::(  ,          "
echo -e "\033[0;34m                                     <==-  :::(,-'(          "
echo -e "\033[0;94m                                     )=-   '::  _.->         "
echo -e "\033[0;96m                                    <==-    ':.' _(          "
echo -e "\033[0;95m                                     <==-    .:'_ (          "
echo -e "\033[0;35m                                      )==- .::'  '->         "
echo -e "\033[0;34m                                       <=- .:;(\`'.(          "
echo -e "\033[0;94m                                        \`)  ':;>  \`          "
echo -e "\033[0;96m                                   .-.  <    :;(             "
echo -e "\033[0;95m                                 <\`.':\  )    :;>            "
echo -e "\033[0;35m                                < :/<_/  <  .:;>             "
echo -e "\033[0;34m                                < '\`---'\`  .::(\`             "
echo -e "\033[0;35m                                 <       .:;>'               "
echo -e "\033[0;34m                                  \`-..:::-'\`                 "
              

}

function clam {                                                                                            
                                                                                            
                                                                                            
echo -e "\033[0;34m                                  _.-''|''-._               "
echo -e "\033[0;94m                                .-'     |     \`-.           "
echo -e "\033[0;96m                              .'\       |       /\`.         "
echo -e "\033[0;95m                            .'   \      |      /   \`.       "
echo -e "\033[0;35m                            \     \     |     /     /       "
echo -e "\033[0;34m                             \`\    \    |    /    /'        "
echo -e "\033[0;94m                               \`\   \   |   /   /'          "
echo -e "\033[0;96m                                 \`\  \  |  /  /'            "
echo -e "\033[0;95m                                _.-\`\ \ | / /'-._           "
echo -e "\033[0;35m                               {_____\`\\|//'_____}          "
echo -e "\033[0;34m                                       \`-'                  "
echo -e "\033[0;34m                                                            "
               
}
       
function orca {

echo -e "\033[0;34m                                                                                "
echo -e "\033[0;94m                                      8b.                                       "
echo -e "\033[0;96m                                      888b                                      "
echo -e "\033[0;95m                                      8888b                                     "
echo -e "\033[0;35m                                      88888b                                    "
echo -e "\033[0;34m                                      888888b                                   "
echo -e "\033[0;94m                                    .d88888888b.__                              "
echo -e "\033[0;96m                              _.od888888888888888888boo..._                     "
echo -e "\033[0;95m                          .od8888888888888888888888888888888booo.._             "
echo -e "\033[0;35m                       .od888888888888888888888888888888888888888888)           "
echo -e "\033[0;34m                     .d888P'    \"Y88888888888888888888(_   _ )888P\"'          "
echo -e "\033[0;94m                   .d8888Poo.     \`Y88888888888888888P-.\`-\`@'.-'\"\"-.          "
echo -e "\033[0;96m          .oooooood8888888P\"\"'      \`\"Y8888888P.d888P   \`---'\"\"\"\".-'     "
echo -e "\033[0;95m        d888888888'888P'  _...-----..__      'd88888__...------'                "
echo -e "\033[0;35m        \`\"\"Y88888'8888|-'              \`----'|88888P                          "
echo -e "\033[0;34m                \`Y8888b                       Y888P                             "
echo -e "\033[0;94m                 888888b                       \`\"'                             "
echo -e "\033[0;96m                  Y88888                                                        "
echo -e "\033[0;95m                   \`Y88P                                                        "
echo -e "\033[0;34m                     YP                                                         "
echo -e "\033[0;94m                                                                                "
             
             
}


function lobster {
                                                                                              
echo -e "\033[0;34m                                              ,.---.             "
echo -e "\033[0;94m                                    ,,,,     /    _ \`.           "
echo -e "\033[0;96m                                     \\\\   /      \  )          "
echo -e "\033[0;95m                                      |||| /\/\`\`-.__\/           "
echo -e "\033[0;35m                                      ::::/\/_                   "
echo -e "\033[0;34m                      {{\`-.__.-'(\`(^^(^^^(^ 9 \`.========='       "
echo -e "\033[0;94m                     {{{{{{ { ( ( (  (   (-----:=                "
echo -e "\033[0;96m                      {{.-'~~'-.(,(,,(,,,(__6_.'=========.       "
echo -e "\033[0;95m                                      ::::\/\                    "
echo -e "\033[0;35m                                      |||| \/\  ,-'/\            "
echo -e "\033[0;34m                                     ////   \ \`\` _/  )           "
echo -e "\033[0;34m                                    ''''     \  \`   /            "
echo -e "\033[0;94m                                              \`---''             "

}

function twocrabs {
                              
                              
echo -en "\033[0;34m             ,        ,           " ; echo -e "\033[0;95m              ,        ,            "
echo -en "\033[0;94m            /(_,    ,_)\          " ; echo -e "\033[0;35m             /(_,    ,_)\           "
echo -en "\033[0;96m            \ _/    \_ /          " ; echo -e "\033[0;34m             \ _/    \_ /           "
echo -en "\033[0;95m            //        \\          " ; echo -e "\033[0;94m             //        \\           "
echo -en "\033[0;35m            \\ (@)(@) //          " ; echo -e "\033[0;96m             \\ (@)(@) //           "
echo -en "\033[0;34m             \'=\"==\"='/         " ; echo -e "\033[0;95m                \'=\"==\"='/        "
echo -en "\033[0;94m         ,===/        \===,       " ; echo -e "\033[0;35m          ,===/        \===,        "
echo -en "\033[0;96m        \",===\        /===,\"    " ; echo -e "\033[0;34m           \",===\        /===,\"   "
echo -en "\033[0;95m        \" ,==='------'===, \"    " ; echo -e "\033[0;94m           \" ,==='------'===, \"   "
echo -en "\033[0;35m         \"                \"     " ; echo -e "\033[0;96m            \"                \"    "
echo -en "\033[0;34m                                  " ; echo -e "\033[0;95m                                    "
echo -en "\033[0;94m                                  " ; echo -e "\033[0;35m                                    "
echo -en "\033[0;96m                                  " ; echo -e "\033[0;95m"

}


function ray {                                                     
echo -e "\033[0;95m                          (\.-./)                 "
echo -e "\033[0;35m                          /     \                 "
echo -e "\033[0;34m                        .'   :   '.               "
echo -e "\033[0;94m                   _.-'\`     '     \`'-._          "
echo -e "\033[0;96m                .-'          :          '-.       "
echo -e "\033[0;95m              ,'_.._         .         _.._',     "
echo -e "\033[0;35m              '\`    \`'-.     '     .-'\`    \`'     "
echo -e "\033[0;34m                        '.   :   .'               "
echo -e "\033[0;94m                          \_. ._/                 "
echo -e "\033[0;96m                    \       |^|                   "
echo -e "\033[0;95m                     |      | ;                   "
echo -e "\033[0;35m                     \'.___.' /                   "
echo -e "\033[0;34m                      '-....-'                    "

}


function conch {
                                                                              
echo -en "\033[0;34m                ";  echo -en "\033[0;35m                    "; echo -e "\033[0;34m           /\         "
echo -en "\033[0;94m                ";  echo -en "\033[0;34m                    "; echo -e "\033[0;94m          {.-}        "
echo -en "\033[0;96m                ";  echo -en "\033[0;94m        /\          "; echo -e "\033[0;96m         ;_.-'\       "
echo -en "\033[0;95m                ";  echo -en "\033[0;96m       {.-}         "; echo -e "\033[0;95m        {    _.}_     "
echo -en "\033[0;35m       /\       ";  echo -en "\033[0;95m      ;_.-'\        "; echo -e "\033[0;35m         \.-' /  \`,   "
echo -en "\033[0;34m      {.-}      ";  echo -en "\033[0;35m     {    _.}_      "; echo -e "\033[0;34m          \  |    /   "
echo -en "\033[0;94m     ;_.-'\     ";  echo -en "\033[0;34m      \.-' /  \`,    "; echo -e "\033[0;94m           \ |  ,/    "
echo -en "\033[0;96m    {    _.}_   ";  echo -en "\033[0;94m       \  |    /    "; echo -e "\033[0;96m            \|_/      "
echo -en "\033[0;95m     \.-' /  \`, ";  echo -en "\033[0;35m        \ |  ,/     "; echo -e "\033[0;95m                      "
echo -en "\033[0;35m      \  |    / ";  echo -en "\033[0;34m         \|_/       "; echo -e "\033[0;35m       /\   "          
echo -en "\033[0;34m       \ |  ,/  ";  echo -en "\033[0;94m                    "; echo -e "\033[0;34m      {.-}  "
echo -en "\033[0;94m        \|_/    ";  echo -en "\033[0;34m                ";   echo -e "\033[0;94m      ;_.-'\       "
echo -en "\033[0;96m                ";  echo -en "\033[0;94m     /\         ";   echo -e "\033[0;96m     {    _.}_     "
echo -en "\033[0;95m                ";  echo -en "\033[0;96m    {.-}        ";   echo -e "\033[0;95m      \.-' /  \`,   "
echo -en "\033[0;35m                ";  echo -en "\033[0;95m   ;_.-'\       ";   echo -e "\033[0;35m       \  |    /   "
echo -en "\033[0;34m                ";  echo -en "\033[0;35m  {    _.}_     ";   echo -e "\033[0;34m        \ |  ,/    "
echo -en "\033[0;94m                ";  echo -en "\033[0;34m   \.-' /  \`,   ";   echo -e "\033[0;94m         \|_/      "
echo -en "\033[0;34m                ";  echo -e "\033[0;94m    \  |    /   ";
echo -en "\033[0;94m                ";  echo -e "\033[0;96m     \ |  ,/    ";
echo -en "\033[0;96m                ";  echo -e "\033[0;95m      \|_/      ";

}

function raspberry {
echo "$(tput setaf 2)
     .~~.   .~~.
    '. \ ' ' / .'$(tput setaf 1)
     .~ .~~~..~.
    : .~.'~'.~. :
   ~ (   ) (   ) ~
  ( : '~'.~.'~' : )
   ~ .~ (   ) ~. ~
    (  : '~' :  )    $(tput sgr0)Raspberry Pi$(tput setaf 1)
     '~ .~~~. ~'
         '~'
  $(tput sgr0)"
}




function footer {
    echo -e "${COLOR_off}\n\nIt's a beautiful day to be alive."                                                       
    which lsb_release > /dev/null && echo    "OS:       $(lsb_release -a 2>/dev/null | grep Description | cut -f2))"    
    which lsb_release > /dev/null && echo -e "Codename: $(lsb_release -a 2>/dev/null | grep Codename | cut -f2)"      
    which nproc > /dev/null && echo -e       "Cores:    $(nproc)"                                                     
    which free > /dev/null && echo -e        "Memory:   $(free -m | grep ^Mem | awk '{print $2}')m"                   
    echo -e "Welcome to ${COLOR_BIGreen}${HOSTNAME}${COLOR_off}."                                         
}



function show_all {
    echo -e "\033[1;92m * betta      * \033[0m" && betta     
    echo -e "\033[1;92m * smokeshark * \033[0m" && smokeshark
    echo -e "\033[1;92m * octopus    * \033[0m" && octopus   
    echo -e "\033[1;92m * seahorse   * \033[0m" && seahorse  
    echo -e "\033[1;92m * clam       * \033[0m" && clam      
    echo -e "\033[1;92m * orca       * \033[0m" && orca      
    echo -e "\033[1;92m * lobster    * \033[0m" && lobster   
    echo -e "\033[1;92m * twocrabs   * \033[0m" && twocrabs  
    echo -e "\033[1;92m * ray        * \033[0m" && ray       
    echo -e "\033[1;92m * conch      * \033[0m" && conch     
    echo -e "\033[1;92m * raspberry  * \033[0m" && raspberry 
}






function random_motd {
    case  $( ( $RANDOM % 10 )  )  in
        0)  betta         | sudo tee --append /etc/motd ;;    
        1)  smokeshark    | sudo tee --append /etc/motd ;; 
        2)  octopus       | sudo tee --append /etc/motd ;;
        3)  seahorse      | sudo tee --append /etc/motd ;;
        4)  clam          | sudo tee --append /etc/motd ;;
        5)  orca          | sudo tee --append /etc/motd ;;
        6)  lobster       | sudo tee --append /etc/motd ;;
        7)  twocrabs      | sudo tee --append /etc/motd ;;
        8)  ray           | sudo tee --append /etc/motd ;;
        9)  conch         | sudo tee --append /etc/motd ;;
        10) raspberry     | sudo tee --append /etc/motd ;;
    esac
}


if [[ "$1" == "--help" ]] ||
   [[ "$1" == "-h"     ]]
then
    echo "setup-motd.sh"
    echo "Tries to choose a motd based on the hostname of this computer."
    echo "Failing that, it chooses a random one."
    echo "Arguments:"
    echo "    --help             This message."
    echo "    --display          Show all of the motds."
    echo "    --display betta    Show the motd that has a betta in it."

    exit 0
fi


if [[ "$1" == "--display" ]]
then
    case  "$2"  in
       *betta*      ) echo "Showing motd betta     " && betta         ;; 
       *smokeshark* ) echo "Showing motd smokeshark" && smokeshark    ;;
       *octopus*    ) echo "Showing motd octopus   " && octopus       ;;
       *seahorse*   ) echo "Showing motd seahorse  " && seahorse      ;;
       *clam*       ) echo "Showing motd clam      " && clam          ;;
       *orca*       ) echo "Showing motd orca      " && orca          ;;
       *lobster*    ) echo "Showing motd lobster   " && lobster       ;;
       *crab*       ) echo "Showing motd twocrabs  " && twocrabs      ;;
       *conch*      ) echo "Showing motd conch     " && conch         ;;
       *ray*        ) echo "Showing motd ray       " && ray           ;;
       *raspberry*  ) echo "Showing motd raspberry " && raspberry     ;;
       *            ) echo "Showing all." && show_all ;; 
    esac
    footer
    exit 0
fi


TODAY=$(date +"%Y-%m-%d")
echo "Moving current motd to /etc/motd-orig-$TODAY"
sudo cp /etc/motd /etc/motd-orig-$TODAY
echo '' | sudo tee /etc/motd


echo "Choosing motd based on hostname."
case  $HOSTNAME  in
       *betta*      ) echo "Choosing motd betta     " && betta         | sudo tee --append /etc/motd ;;    
       *smokeshark* ) echo "Choosing motd smokeshark" && smokeshark    | sudo tee --append /etc/motd ;; 
       *octopus*    ) echo "Choosing motd octopus   " && octopus       | sudo tee --append /etc/motd ;;
       *seahorse*   ) echo "Choosing motd seahorse  " && seahorse      | sudo tee --append /etc/motd ;;
       *clam*       ) echo "Choosing motd clam      " && clam          | sudo tee --append /etc/motd ;;
       *orca*       ) echo "Choosing motd orca      " && orca          | sudo tee --append /etc/motd ;;
       *lobster*    ) echo "Choosing motd lobster   " && lobster       | sudo tee --append /etc/motd ;;
       *crab*       ) echo "Choosing motd twocrabs  " && twocrabs      | sudo tee --append /etc/motd ;;
       *conch*      ) echo "Choosing motd conch     " && conch         | sudo tee --append /etc/motd ;;
       *ray*        ) echo "Choosing motd ray       " && ray           | sudo tee --append /etc/motd ;;
       *raspberry*  ) echo "Choosing motd raspberry " && raspberry     | sudo tee --append /etc/motd ;;
       *) echo "Nothing applicable.  Choosing a random motd." && random_motd ;;
esac


echo "Adding a footer."
footer | sudo tee --append /etc/motd
