exe= generate_values_4tap.out
flags= -Wall -std=c99

$(exe): generate_values_4tap.c
	gcc -o $(exe) $(flags) generate_values_4tap.c

run: $(exe)
	./$(exe)

clean:
	rm *.out expected_values_temp.txt