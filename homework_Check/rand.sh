#!/bin/sh
#chmod u+x

rand_num=$((1 + RANDOM % 49))
rand_user=""

if [ $rand_num -lt 10 ]
then
	rand_user="2560$rand_num"
else
	rand_user="256$rand_num"
fi

name=$(grep $rand_user /etc/passwd | cut -d : -f 5 | cut -d , -f 1)

echo $rand_user $name