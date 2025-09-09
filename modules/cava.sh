#!/bin/bash

bars=("▁" "▂" "▃" "▄" "▅" "▆" "▇" "█")

cava -p ~/.config/cava/config | while read -r line; do
    IFS=';' read -ra values <<< "$line"
    
    # Find max value in the current line
    max=0
    for val in "${values[@]}"; do
        if [[ "$val" =~ ^[0-9]+$ ]] && (( val > max )); then
            max=$val
        fi
    done
    
    # Avoid division by zero
    (( max == 0 )) && max=1
    
    output=""
    for val in "${values[@]}"; do
        if [[ "$val" =~ ^[0-9]+$ ]]; then
            # Normalize val to index 0-7 using the max found
            index=$(( val * (${#bars[@]} - 1) / max ))
            # Clamp index between 0 and 7
            if (( index < 0 )); then index=0; fi
            if (( index > 7 )); then index=7; fi
            output+="${bars[$index]} "
        fi
    done

    echo "{\"text\": \"${output% }\", \"class\": \"cava\"}"
done
