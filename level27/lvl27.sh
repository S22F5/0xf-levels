#!/bin/bash

# nc 193.200.241.188 2727 | a.sh

  while IFS= read -r line; do
    echo "$line"
    output=$(echo "$line" | grep "=?"| head -c -3 | calc -p)
    printf "%s" "$output" | xclip -selection clipboard
  done