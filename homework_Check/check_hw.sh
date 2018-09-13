#!/bin/sh
#chmod u+x

# gonna use argc 
ARGC=$#
E_BADARGS=65 

EXPECTED_ONE_ARGS=1


# Path of where to find the folder of student's homeworks. 
# Just change here for your disire.
PATH_FOLDERS="/u1/class"

# folder from student you are wishing to copy. Change here for your special case
#FOLDER_TO_COPY="cs256/Homework/assig1"

# for labs
FOLDER_TO_COPY="cs256/Labs/lab_1"

# base of classe range
BASE_CLASS="cs"

# Range of folders for each student
# 25600 - 25650 for my class example
RANGE_FOLDERS=(25600 25649)

# Thus, an example of class would be cs25619

# Where to copy to
#copy_to="/u1/h2/tsantos2/cs256/collected/hw/hw1"

# for lab
copy_to="/u1/h2/tsantos2/cs256/collected/labs/lab_1"

# Ouput confirmation file
out_file="output_file.txt"

# All files copied
folders_copied=""

# All files copied
folders_not_copied=""
# check if class folder exist and also if folder to copy to exist
if [ ! -d $copy_to ]; then
  echo "Folder $copy_to do not exist"
  exit $E_BADARGS
fi

if [ ! -d $PATH_FOLDERS ]; then
  echo "Folder $PATH_FOLDERS do not exist"
  exit $E_BADARGS
fi

if [ $# -lt $EXPECTED_ONE_ARGS ]
then
# All homeworks must be collect
  for folder_num in `seq ${RANGE_FOLDERS[0]} ${RANGE_FOLDERS[1]}`;
  do
#     student folder
    folder_base=$BASE_CLASS$folder_num

#     Check if student's main folder exist
    main_folder="$PATH_FOLDERS/$folder_base"
    if [ ! -d $main_folder ]; then
#      echo "Student $folder_base do not exist"
      true
    else
#     Check if student's especial folder exist - hw, lab or any other you want to collect
      folder="$main_folder/$FOLDER_TO_COPY"
      if [ ! -d $folder ]; then
#        echo "Student $folder_base do not have $FOLDER_TO_COPY"
        folders_not_copied="$folders_not_copied $folder_base"
      else
#       Then, copy the holder
        copy_to_stu="$copy_to/$folder_base"
        if [ ! -d $copy_to_stu ]; then
          mkdir $copy_to_stu
        fi
        cp -r $folder $copy_to_stu 
        folders_copied="$folders_copied $folder_base"
      fi

    fi
  done   


else
# just gonna collect for the specific student
  folder_base=($"$1")
  main_folder="$PATH_FOLDERS/$folder_base"
  if [ ! -d $main_folder ]; then
#    echo "Student $folder_base do not exist"
  true
  else
#    Check if student's especial folder exist - hw, lab or any other you want to collect
    folder="$main_folder/$FOLDER_TO_COPY"
    if [ ! -d $folder ]; then
#      echo "Student $folder_base do not have $FOLDER_TO_COPY"
      folders_not_copied="$folders_not_copied $folder_base"
    else
#       Then, copy the holder
      copy_to_stu="$copy_to/$folder_base"
      if [ ! -d $copy_to_stu ]; then
        mkdir $copy_to_stu
      fi
      cp -r $folder $copy_to_stu 
      folders_copied="$folders_copied $folder_base"
    fi

  fi
fi

file_path="$copy_to/$out_file"
origin_path="$out_file"
if [ ! -e $file_path ]; then
  touch $file_path
else
  rm $file_path
  touch $file_path
fi

# copy results to file, to output
echo " " >> $file_path
echo "        ####### Succefully copied $FOLDER_TO_COPY from Students #######" >> $file_path
echo " " >> $file_path
n=1
out=""
for i in $folders_copied; do
  out="$out$i "
  if [ $n = 7 ]; then
    echo $out >> $file_path
    n=0
    out=""
  fi
  n=$((n + 1))
done
echo $out >> $file_path

echo " " >> $file_path
echo "       ####### Weren't able to copy $FOLDER_TO_COPY from Students #######" >> $file_path
echo " " >> $file_path
n=1
out=""
for i in $folders_not_copied; do
  out="$out$i "
  if [ $n = 7 ]; then
    echo $out >> $file_path
    n=0
    out=""
  fi
  n=$((n + 1))
done
echo "$out" >> $file_path
echo " " >> $file_path

# make a copy for a file where we did execute the bash script
if [ -e $origin_path ]; then
  rm $origin_path
fi

cp "$file_path" "."







