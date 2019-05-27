#!/bin/bash
# Mass APi Reverse 
# 27 Mei 2019
# By Nicolas Julian. 
# Special Thanks Teguh Aprianto (https://github.com/secgron() | Malhadi Jr 
# Api Souce : https://github.com/secgron/Information-Gathering-API

RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
ORANGE='\033[0;33m' 
PURPLE='\033[0;35m'
NC='\033[0m'
GRN="\e[32m"


cat <<EOF

      \_/       
     (* *)        
    __)#(__
   ( )...( )(_) 1%  Luck
   || |_| ||//  1%  Skill 
>==() | | ()/   98% Never Giveup
    _(___)_
   [-]   [-]MJP
--------------------------------------------

          Mass IP Reverse  - Nicolas Julian 
               27 Mei 2019

--------------------------------------------

EOF

usage() { 
  echo "Usage: ./myscript.sh COMMANDS: [-i <list.txt>] [-r <folder/>] [-l {1-1000}] [-t {1-10}] [-d {y|n}]

Command:
-i (domains.txt)     File input that contain domain to exploit
-r (result/)         Folder to store the all result 
-l (60|90|110)       How many list you want to send per delayTime
-t (3|5|8)           Sleep for -t when request is reach -l fold
-d (y|n)             Delete the list from input file per request
"
  exit 1 
}

# Assign the arguments for each
# parameter to global variable
while getopts ":i:r:l:t:dh" o; do
    case "${o}" in
        i)
            inputFile=${OPTARG}
            ;;
        r)
            targetFolder=${OPTARG}
            ;;
        l)
            sendList=${OPTARG}
            ;;
        t)
            perSec=${OPTARG}
            ;;
        s)
            socks=${OPTARG}
            ;;
        d)
            isDel==${OPTARG}
            ;;
        h)
            usage
            ;;
    esac
done

#Prepareing before attack

if [[ $inputFile == '' || $targetFolder == '' || $isDel == '' || $sendList == '' || $perSec == '' ]]; then
  cli_mode="interactive"
else
  cli_mode="interpreter"
fi

SECONDS=0

# Asking user whenever the
# parameter is blank or null
if [[ $inputFile == '' ]]; then
  # Print available file on
  # current folder
  # clear
  tree
  read -p "Enter domainlist file: " inputFile
fi

if [[ $targetFolder == '' ]]; then
  read -p "Enter target folder: " targetFolder
  # Check if result folder exists
  # then create if it didn't
  if [[ ! -d "$targetFolder" ]]; then
    echo "[+] Creating $targetFolder/ folder"
    mkdir $targetFolder
  else
    read -p "$targetFolder/ folder are exists, append to them ? [y/n]: " isAppend
    if [[ $isAppend == 'n' ]]; then
      exit
    fi
  fi
else
  if [[ ! -d "$targetFolder" ]]; then
    echo "[+] Creating $targetFolder/ folder"
    mkdir $targetFolder
  fi
fi

if [[ $isDel == '' ]]; then
  read -p "Delete list per check ? [y/n]: " isDel
fi

if [[ $sendList == '' ]]; then
  read -p "How many list send: " sendList
fi

if [[ $perSec == '' ]]; then
  read -p "Delay time: " perSec
fi



request() {
  duration=$SECONDS
  printf "${ORANGE}[$2] REVERSING RIGHTNOW => $1 \n"
  send=`curl -s --max-time 60 "https://api.hack.co.id/reverseip/?ip=$1"`
    clean=$(echo $send | grep -Po '"name": *\K"[^"]*"' | tr -d '"' )
        if [[ $send == "" ]]; then
          printf "${CYAN}[$2] REVERSING $1 => Time out  \n"
          echo "$1" >> $4/timeout.txt
        else
          echo "$clean" >> $4/domain.txt

printf "\r"
fi      
}

#Cleaning list
cat $inputFile | sed '/^[[:space:]]*$/d' | sort -u >> $inputFile".clean" && rm $inputFile && mv $inputFile".clean" $inputFile

IFS=$'\r\n' GLOBIGNORE='*' command eval  'domainlist=($(cat $inputFile))'
con=1

echo "[+] Job start with $sendList IP per $perSec seconds"
baris=`wc -l < $inputFile`

for (( i = 0; i < $baris; i++ )); do
  alamatip="${domainlist[$i]}"
  indexer=$((con++))
  tot=$((totalLines--))
  fold=`expr $i % $sendList`
  if [[ $fold == 0 && $i > 0 ]]; then
    header="`date +%H:%M:%S`"
    duration=$SECONDS
    printf "Waiting $perSec seconds. $(($duration / 3600)) hours $(($duration / 60 % 60)) minutes and $(($duration % 60)) seconds elapsed, ratio ${YELLOW}$sendList domain${NC} / ${CYAN}$perSec seconds${NC}\n"
    printf "\r"
    sleep $perSec
  fi

  request "$alamatip" "$indexer" "$tot" "$targetFolder" "$inputFile"  &
  
  if [[ $isDel == 'y' ]]; then
    grep -v -- "$alamatip" $inputFile > "$inputFile"_temp && mv "$inputFile"_temp $inputFile
  fi

done 
printf "${PURPLE}[+]Waiting until all progress done \n"
wait
printf "${PURPLE}[+]Sorting All Your Domain Result[+] \n"
printf "\r"

#Cleaning All Result
sed 's/\s\+/\n/g' $targetFolder/domain.txt >> .sementara && mv .sementara $targetFolder/domain.txt
cat $targetFolder/domain.txt
printf "${GRN}[+]Congratulations !! You got `wc -l < $targetFolder/domain.txt` new scope \n"
printf "${GRN}[+]Saved at `pwd`/$targetFolder/domain.txt \n"
printf "\r"
exit