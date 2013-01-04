echo -en $COLOR_White
(probexit 0.1 && echo "Believe in yourself.") ||
    (probexit 0.3 && fortune -s | fold -s) ||
    (probexit 0.3 && fortune /home/swirepe/pers/quotes/compiled | fold -s)
echo -en $COLOR_off
