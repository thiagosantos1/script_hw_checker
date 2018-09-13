#!/bin/sh
#chmod u+x

ARGC=$#

EXPECTED_ARGS=1
E_BADARGS=65


if [ $# -lt $EXPECTED_ARGS ]
then
  echo "Paramters required: <homework>"
  exit $E_BADARGS
fi

HW="$1"

# List of homework to check. --> Must change everytime create new homeworks
HW_Check="hw1 hw2 hw3 hw4"
HW_List=($HW_Check)

Prof_Folder="hw_check/"

# Check if homework exist
hw_exist=-1
for i in $HW_Check; do
	if [ $i = $HW ]; then
		hw_exist=1
    	break
  	fi
done

if [ $hw_exist -lt 1 ]; then
	echo "There is not a check for $HW"
    exit $E_BADARGS
fi

# Check if student has created file
FL="$HW.c"
if [ -e $FL ]
then
	make clean rm_out=$HW;
#	make clean rm_out=$Prof_Folder$HW;
    gcc $FL -o "$HW"
#    gcc "$Prof_Folder$HW.c" -o "$Prof_Folder/$HW"
else
    echo "$HW.c does not exist"
    exit $E_BADARGS
fi

# continue only if output was succefully created
FL="$HW"
if [ -e $FL ]
then
    continue
else
    echo "Your program did not compile! See the problems above"
    exit $E_BADARGS
fi

# check if professor/me has created an output file for comparison
FL="$Prof_Folder$HW"
if [ -e $FL ]
then
    continue
else
    echo "I forgot to put the .out file for this problem. Please ask me."
    exit $E_BADARGS
fi

# Run all test predefined in file inputTest.txt
inputs_file="hw_check/input_$HW.txt"
index=0
inputs[$index]=0
while IFS= read line
do
	inputs[$index]=$line
	index=$((index + 1))
done <"$inputs_file"

file_test="hw_check/input.txt"
passed_check=1 
input_index=0
for (( input_index=0; $input_index<$index; $input_index++ ))
do
#	Create a file to be execute
	exec 3<> "$file_test"
		echo "${inputs[$input_index]}" >&3
	exec 3>&-
# execute program from professeor and student, to create the output to be compared
	make run c_out=$HW inputs=$file_test;

# execute hwCheck.py to compare answers
	python3 hw_check/hwCheck.py

# read the comparison to make sure to stop as soon it fails in one test
	comparison="hw_check/comparison.txt"
	while IFS= read line
	do
		return_output=$line
		break
	done <"$comparison"

	if [ $return_output = -1 ];
	then
		passed_check=-1
		break
	fi
done

if [ $passed_check = 1 ];
then
	clear
    echo "\n\t### You program has passed all checks! Well done ###\n"
else
#   jump the first iteration(not to print first line)
	jump=0
	while IFS= read -r line;
	do
		if [ $jump = 0 ];
		then
			jump=1
			continue
		fi
# to print the input causing the error
		if [ $jump = 2 ];
		then
			jump=3
			echo "Inputs used:" "${inputs[$input_index]}\n"
		fi

		echo $line
		jump=$((jump+1))
		
	done <"$comparison"

    echo "Please, fix your code. Don't give it up\n"

fi




