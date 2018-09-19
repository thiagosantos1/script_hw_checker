#!/bin/sh
#chmod u+x

# folder with homeworks
hws="/u1/h2/tsantos2/cs256/collected/hw/hw1"

HW_Check="hw1 hw2 hw3 hw4 hw5 hw6"

full_grade=(1.5 1.5 1.5 1.5 2 2)

hw_stu="assig1"

# for lab
#hws="/u1/h2/tsantos2/cs256/collected/labs/lab_1"
lab="/u1/h2/tsantos2/cs256/collected/labs/lab_1"
#HW_Check="hw1 hw2 hw3 hw4 hw5"

#full_grade=(2 2 2 2 2)

#hw_stu="lab_1"

# Ouput confirmation file
out_file="grade.txt"

# for an especific student, giving on the argv
EXPECTED_ONE_ARGS=1

# set to create new grade file(1) or to append a new score(2)
new_grade=1

DIRS=""
index=0

# To check if student got the question right
well_done=0

if [ $# -lt $EXPECTED_ONE_ARGS ]
then
	DIRS=`ls -l $hws | egrep '^d' | awk '{print $9}'`
else
	DIRS=($"$1")
fi

for dir in $DIRS 
do
	sum_grade=0.0
	std_fld="$hws/$dir/$hw_stu"
	grades="$std_fld/$out_file"

	if [ ! -d $std_fld ]; then
  	echo "Student do not exist or do not have homework $hw_stu"
  else
	# create file if do not exist
		if [ ! -e $grades ]; then
	  	touch $grades
	  else
	  	if [ $new_grade -lt 2 ]; then
	  		# remove and create a new one. Else, will just append it
	  		rm $grades
	  		touch $grades
	  	else
	  		echo " " >> $grades
	  	fi
		fi
		index=0
		for hw in $HW_Check; do
			well_done=0
			homework="$std_fld/$hw.c"
			if [ ! -e $homework ]; then
				echo "$hw --> Grade: 0   You did not do homework $hw" >> $grades
			else
				cd $std_fld
				check_out="check_out.txt"
				if [ ! -e $check_out ]; then
	  			touch $check_out
	  		else
	  			rm $check_out
	  			touch $check_out
	  		fi
				./check_hw.sh $hw >> $check_out
				out="$hw --> Grade:"
				# then, check the output to see if student got right answer
				while IFS='' read -r line || [[ -n "$line" ]]; do
    			if [[ $line =~ "passed" ]] ; then 
    				out="$out ${full_grade[$index]}"
    				echo $out >> $grades
    				#sum_grade=$(($sum_grade + ${full_grade[$index]}))
    				sum_grade=$(echo "scale=2; $sum_grade + ${full_grade[$index]}" | bc)
    				well_done=2
    			fi
				done < "$check_out"
			  if [ $well_done -lt 1 ]
				then
  				out="$out I gotta check"
  				echo $out >> $grades
  			fi

			fi
			index=$((index + 1))
		done
		
		echo "Total grade: $sum_grade" >> $grades
	fi
done