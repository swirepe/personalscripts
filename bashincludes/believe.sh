echo -en $COLOR_White
(probexit 0.1 && echo "Believe in yourself.") ||
    (probexit 0.3 && fortune -s)
echo -en $COLOR_off
