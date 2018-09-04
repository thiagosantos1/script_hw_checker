# Script in python to check if output matches

import sys
import re
import os

# open files to compare asnwers
prof_file = "hw_check/out_prof.txt"
stu_file = "hw_check/out_stud.txt"

try:
  output_prof = open(prof_file, 'r')
  prof_all_lines = output_prof.readlines()
  output_prof = open(prof_file, 'r')
except IOError as exc:
	with open('hw_check/comparison.txt', 'w') as output:
		output.write(str(-1)+"\n") # flag, to check later if there was a problem
		output.write("Failure opening professor's file " +"\n")
	sys.exit(2)

try:
  output_stud = open(stu_file, 'r')
  stud_all_lines = output_stud.readlines()
  output_stud = open(stu_file, 'r')
except IOError as exc:
	with open('hw_check/comparison.txt', 'w') as output:
		output.write(str(-1)+"\n") # flag, to check later if there was a problem
		output.write("Failure opening student's file "+"\n" )
	sys.exit(2)

answers_equal = True

# compare answers
prof_output = output_prof.readline()
while prof_output:
	stud_output = output_stud.readline()

	# Remove spaces and new lines
	stud_output = stud_output.replace(" ", "")
	prof_output = prof_output.replace(" ", "")

	stud_output = stud_output.replace('\n', "")
	prof_output = prof_output.replace('\n', "")

	# Remove ponctuation
	stud_output = re.sub(r'[^\w\s]','',stud_output)
	prof_output = re.sub(r'[^\w\s]','',prof_output)

	# compare
	if prof_output != stud_output:
		answers_equal = False
		break

	prof_output = output_prof.readline()


if answers_equal:
	with open('hw_check/comparison.txt', 'w') as output:
		output.write(str(1)+"\n") # flag, to check later if there was a problem
		output.write("no problem so far"+"\n")
else:
	os.system('cls' if os.name == 'nt' else 'clear')
	with open('hw_check/comparison.txt', 'w') as output:
		output.write(str(-1)+"\n") # flag, to check later if there was a problem
		#print("\n\t\t### Something is wrong ###")
		output.write("\t\t### Something is wrong ###"+"\n")
		output.write("Your output:"+"\n")
		#print("Your output:")
		for x in stud_all_lines:
			output.write(x+"\n")
			#print(x)
		output.write("Correct output:"+"\n")
		#print("Correct output:")
		for x in prof_all_lines:
			output.write(x+"\n")
			#print(x)

