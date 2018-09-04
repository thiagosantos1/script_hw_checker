check:
	clear
	@chmod u+x check_hw.sh
	@./check_hw.sh $(homeWork)

run:
	@./$(c_out) < $(inputs) >"hw_check/out_stud.txt"
	@./hw_check/$(c_out) < $(inputs) >"hw_check/out_prof.txt"

clean:
	rm -f *.out
	rm -f $(rm_out)


