name=$(grep $1 /etc/passwd | cut -d : -f 5 | cut -d , -f 1)
echo $name
