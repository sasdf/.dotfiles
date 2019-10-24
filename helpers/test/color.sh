#!/bin/bash

for i in {30..37} ; do
    printf "\e[%sm\u2588\u2588\u2588\e[0m " "$i"
done
echo ""

for i in {30..37} ; do
    printf "\e[1;%sm\u2588\u2588\u2588\e[0m " "$i"
done
echo ""

for i in {0..15} ; do
    printf "\e[48;5;%sm%3d\e[0m " "$i" "$i"
    if (( i % 8 == 7 )); then
        printf "\n";
    fi
done
echo ""

for a in {0..1} ; do
    for b in {0..5} ; do
        for c in {0..2} ; do
            for d in {0..5} ; do
                color=$((a * 108 + b * 6 + c * 36 + d + 16))
                (( b >= 3 )) && cursor="0" || cursor="15"
                printf "\e[48;5;%sm\e[38;5;%sm%3d\e[0m " "$color" "$cursor" "$color"
            done
            printf "    "
        done
        printf "\n";
    done
    printf "\n"
done

for a in {0..1} ; do
    for b in {0..11} ; do
        color=$((a * 12 + b + 232))
        (( a >= 1 )) && cursor="0" || cursor="15"
        printf "\e[48;5;%sm\e[38;5;%sm%3d\e[0m " "$color" "$cursor" "$color"
    done
    printf "\n"
done
echo ""

awk -v term_cols="${width:-$(tput cols || echo 80)}" 'BEGIN{
    s="/\\";
    for (colnum = 0; colnum<term_cols; colnum++) {
        r = 255-(colnum*255/term_cols);
        g = (colnum*510/term_cols);
        b = (colnum*255/term_cols);
        if (g>255) g = 510-g;
        printf "\033[48;2;%d;%d;%dm", r,g,b;
        printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
        printf "%s\033[0m", substr(s,colnum%2+1,1);
    }
    printf "\n";
}'
echo ""
