#!/bin/bash

#note: text editors number columns and lines starting at 1, not 0
#I follow that logic in this program, so all my arrays start at 
#number at 1 for the first char on a line and the number 1 for the 
#first line in a file. My reason is so that when you go into a 
#text editor and look at the info for what line and col you are on,
#it will show you the same number as displayed by this program

#NOTE: I don't know why, but you have to have a blank line at the end of the file for this all to work
#My guess is that it has something to do with the IFS= read -r line statement in the while loop

#if [ $1 -eq 1 ]
#then
#file_input=.testmap
#else
file_input=Level2Map #file that is being passed to shell script as an argument
#fi

declare -A file_map #pseudo-2D array to hold value and location of each char in file
no_lines=0
no_cols=0
line_no=1
function setArrayContents(){
#x=line number
#y=column/character number
#z=value of character at line x and col y
#file_map[x,y]=z
#Take this 2 line example file:
#1234
#5678
#This file would be represented like this:
#file_map[1,1]=1
#file_map[1,2]=2
#file_map[1,3]=3
#file_map[1,4]=4
#file_map[2,1]=5
#file_map[2,2]=6
#file_map[2,3]=7
#file_map[2,4]=8

#note: removing IFS= will cause loop to ignore space characters at end of lines
while IFS= read -r line 
do
  numChars=${#line} #set numChars equal to the amount of chars in the current line
  for (( i=0; i<numChars; i++ )); do
	current_char=${line:$i:1} #The notation for this is: ${variable:offset:length}
	file_map[$line_no,$i]=$current_char #set file_map[line_no,$i] to value of char on line "line_no" at col "i"
  done
  ((line_no++))
done < "$file_input" #redirect the contents of file_input as input given to be read in while loop
no_lines=$line_no #line_no will equal the number of the last line in the file, which should be the total no of lines
no_cols=$numChars #assuming numChars will be the same on each line, set the no_cols equal to that
}

if test -f ".resume.txt"; then
while read a b rest; do player_x=$a; player_y=$b; done < .resume.txt

else
player_x=1
player_y=2
fi

function displayFileMap(){
for (( i=1; i<no_lines; i++ ));
do
echo
for (( j=0; j<no_cols; j++ ));
do
if [ $i -eq $player_y ] && [ $j -eq $player_x ]
then
echo -n "P"
else
echo -n "${file_map[$i,$j]}"
fi
done
done
echo
}

function movement(){
while true; do
        read -p "Move? " movement
        case $movement in
        "left" | "l")
	player_x2=$(( player_x-1 ))
	fon=${file_map[$player_y,$player_x2]}
	if [[ "$fon" == "|" ]] || [[ "$fon" == "X" ]]; then
	echo "Ouch"
	else
	clear
	player_x=$(( player_x -1 ))
	displayFileMap
	fi
        ;;
        "right" | "r")
	player_x2=$(( player_x+1 ))
        fon=${file_map[$player_y,$player_x2]}
        if [[ "$fon" == "|" ]] || [[ "$fon" == "X" ]]; then
	echo "Ouch"
        else
	clear
        player_x=$player_x2
        displayFileMap
        fi
        ;;
        "up" | "u")
        player_y2=$(( player_y-1 ))
        fon=${file_map[$player_y2,$player_x]}
        if [[ "$fon" == "|" ]] || [[ "$fon" == "X" ]]; then
	echo "Ouch"
        else
	clear
        player_y=$player_y2
        displayFileMap
        fi
        ;;
        "down" | "d")
        player_y2=$(( player_y+1 ))
        fon=${file_map[$player_y2,$player_x]}
        if [[ "$fon" == "|" ]] || [[ "$fon" == "X" ]]; then
	echo "Ouch!"
        else
	clear
        player_y=$player_y2
        displayFileMap
        fi
        ;;
	"rest")
	echo 'Remember! Use ./level2.sh to come back to the maze!'
	echo "$player_x	$player_y">.resume.txt
	break
	;;
	"reset")
	echo 'temporary'
	rm .resume.txt
	;;
        *) echo "You Failed!"
        ;;
        esac
	#C - character, N - note
	fon=${file_map[$player_y,$player_x]}
	if [[ "$fon" == "N" ]]; then
		cat .level2Note
	elif [[ "$fon" == "C" ]]; then
		if test -f "Apple"; then
			cat ./.noblePawnChat2
		else
			cat ./.noblePawnChat1
			player_x=$(( player_x-1 ))
		fi

	elif [[ "$fon" == "E" ]]; then
		cp -r ../.Level3 ../Level3
		cat .pawnNote2
		break
	fi
done
}

#npc.txt
function main(){ #an emulation of how the main function like that of C/C++ works. I will run everything in this
setArrayContents
displayFileMap
movement
}
main
