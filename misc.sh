function lastrun {
  history | tail -2 | awk '{print $2; exit}'
}

