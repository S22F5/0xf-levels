#!/bin/bash
#create filestructure
mkdir 1
#download initial image
wget https://0xf.at/data/tmp/476922fd7e5663e0bfd95ae938cd1150.png -O 1/o.png -q
#split image into individual pixels
convert 1/o.png -crop 1x1 1/%d.png
#get black pixels
cd 1 || exit
rawnumbers=$(find . -size 360c -printf '%f\n' | sed -e 's/\.png$//' | xargs -n1 | sort -g | xargs)
read -a numbers <<< "$rawnumbers"
cd .. || exit
identify -format '%h' 1/o.png
printf "\n"
#cleanup
rm -Rvf 1/ 1> /dev/null
#output
#decode
#tr 0123456789 abcdefghij <<< "8"

e=0

numbertoalphabet () {
let inputnr=$1-$e  # z
declare -i i=$[ 97+${inputnr} ]
c=$(printf "\\$(printf '%03o' $i)")
printf $c
let e=$e+26
}





numbertoalphabet ${numbers[0]}
numbertoalphabet ${numbers[1]}
numbertoalphabet ${numbers[2]}
numbertoalphabet ${numbers[3]}
numbertoalphabet ${numbers[4]}
numbertoalphabet ${numbers[5]}
numbertoalphabet ${numbers[6]}
numbertoalphabet ${numbers[7]}
numbertoalphabet ${numbers[8]}
numbertoalphabet ${numbers[9]}
numbertoalphabet ${numbers[10]}
numbertoalphabet ${numbers[11]}
numbertoalphabet ${numbers[12]}
numbertoalphabet ${numbers[13]}
numbertoalphabet ${numbers[14]}
numbertoalphabet ${numbers[15]}
numbertoalphabet ${numbers[16]}
numbertoalphabet ${numbers[17]}
numbertoalphabet ${numbers[18]}
numbertoalphabet ${numbers[19]}
numbertoalphabet ${numbers[20]}
numbertoalphabet ${numbers[21]}
numbertoalphabet ${numbers[22]}
numbertoalphabet ${numbers[23]}
numbertoalphabet ${numbers[24]}
numbertoalphabet ${numbers[25]}
numbertoalphabet ${numbers[26]}
numbertoalphabet ${numbers[27]}
numbertoalphabet ${numbers[28]}
numbertoalphabet ${numbers[29]}
numbertoalphabet ${numbers[30]}
numbertoalphabet ${numbers[31]}
numbertoalphabet ${numbers[32]}
numbertoalphabet ${numbers[33]}
numbertoalphabet ${numbers[34]}
numbertoalphabet ${numbers[35]}
numbertoalphabet ${numbers[36]}
numbertoalphabet ${numbers[37]}
numbertoalphabet ${numbers[38]}
numbertoalphabet ${numbers[39]}
numbertoalphabet ${numbers[40]}

printf "\n"

