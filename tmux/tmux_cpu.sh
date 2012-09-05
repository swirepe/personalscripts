mpstat -P ALL 2 1 | awk '{if (NR > 3 && NR < 9 ){printf "[cpu-%d:%000.2f]", $3, $4 }}' | tr -d '\n'
