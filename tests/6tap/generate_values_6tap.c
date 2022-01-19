//==========================================================
//
// Helper file for 6-Tap FIR filter to generate expected
// values based on input signals and tap coefficients.
//
// Last updated on 02/19/2022
// Created by Cole Maxwell
//
//==========================================================

#include <stdio.h>
#include <math.h>
#include <string.h>

// Declare the number of taps.
const int fir_order = 6;
// Define filter coefficients
const int coeff[] = { 2, 9, 5, 9, 5, 2 };
// Define input signals
const int signal_in[] = {
     0,  2,  4,  6,  8,  9,  9,  9,  9,  7,  5,  3,  1, -1, -3, -5,
    -7, -9, -9, -9, -9, -8, -6, -4, -2,  0,  2,  4,  6,  8,  9,  9,
     9,  8,  7,  5,  3,  1, -1, -3, -6, -7, -9, -9, -9, -9, -8, -6,
    -4, -2,  0,  2,  5,  7,  8,  9,  9,  9,  8,  7,  5,  3,  0, -1,
    -4, -6, -7, -9, -9, -9, -9, -8, -6, -4, -2,  0,  2,  5,  7,  8,
     9,  9,  9,  8,  7,  5,  3,  0, -1, -4, -6, -8, -9, -9, -9, -9,
    -8, -6, -4, -1,  0,  3,  5,  7,  8,  9,  9,  9,  8,  7,  5,  3,
     0, -1, -4, -6, -8, -9, -9, -9, -9, -8, -6, -4, -1,  0,  3,  5};

void write_coefficients();
void write_expected_values();
void truncate_expected_values();

//==========================================================
// Main program
//==========================================================
int main (int argc, char *argv[])
{
    // Write coefficients to a new file or overwrite the existing file.
    write_coefficients();
    // Write expected values to a new file or overwrite the existing file.
    write_expected_values();
    // Trucate expected values to format for test bench.
    truncate_expected_values();

    return 0;
}

// Write coefficients to a new file or overwrite the existing file.
void write_coefficients() {

    printf("\n...generating coefficients for 4 taps...:\n");
    // Write coefficients to a new file or overwrite the existing file.
    FILE *fp1;
    fp1 = fopen("coeff_6tap.txt", "w");
    for (int i=0; i < fir_order; i++) {
        fprintf(fp1, "%.4x // %d\n", coeff[i], coeff[i]);
    }
    fclose(fp1);
    printf("...finished generating coefficients for 6 taps...:\n");
}

// Write expected values to a new file or overwrite the existing file.
void write_expected_values() {

    printf("\n...generating values for 4 taps...:\n");

    // Write expected values to a new file or overwrite the existing file.
    FILE *fp2;
    fp2 = fopen("expected_values_temp.txt", "w");
    // Calculate the first six values manually until the all the taps have valid values.
    int signal_one = signal_in[0]*coeff[0];
    int signal_two = signal_in[1]*coeff[0] + signal_in[0]*coeff[1];
    int signal_three = signal_in[2]*coeff[0] + signal_in[1]*coeff[1] + signal_in[0]*coeff[2];
    int signal_four = signal_in[3]*coeff[0] + signal_in[2]*coeff[1] + signal_in[1]*coeff[2] + signal_in[0]*coeff[3];
    int signal_five = signal_in[4]*coeff[0] + signal_in[3]*coeff[1] + signal_in[2]*coeff[2] + signal_in[1]*coeff[3] + signal_in[0]*coeff[4];
    int signal_six = signal_in[5]*coeff[0] + signal_in[4]*coeff[1] + signal_in[3]*coeff[2] + signal_in[2]*coeff[3] + signal_in[1]*coeff[4] + signal_in[0]*coeff[5];

    // Write first six expected values to file.
    fprintf(fp2, "%.4x // %d\n", signal_one, signal_one);
    fprintf(fp2, "%.4x // %d\n", signal_two, signal_two);
    fprintf(fp2, "%.4x // %d\n", signal_three, signal_three);
    fprintf(fp2, "%.4x // %d\n", signal_four, signal_four);
    fprintf(fp2, "%.4x // %d\n", signal_five, signal_five);
    fprintf(fp2, "%.4x // %d\n", signal_six, signal_six);

    // Finish calculating and writing expected values for the remaining input signals.
    for (int j=fir_order; j<128; j++) {
        int signal_out = signal_in[j]*coeff[0] + signal_in[j-1]*coeff[1] + signal_in[j-2]*coeff[2] + signal_in[j-3]*coeff[3] + signal_in[j-4]*coeff[4] + signal_in[j-5]*coeff[5];          
        if (signal_out < 0) {
            // Flag negative values for truncating later on.            
            fprintf(fp2, "n%.4x // %d\n", signal_out, signal_out);
        } else {  
            fprintf(fp2, "%.4x // %d\n", signal_out, signal_out);
        }
    }
    fclose(fp2);
    printf("...finished generating values for 6 taps...:\n");
}

void truncate_expected_values() {

    printf("\n...truncating negative values to 4 digits...:\n");
    
	char line [30];
	FILE *fp3 = NULL;
    FILE *fp4 = NULL;
	fp3 = fopen("expected_values_temp.txt","r+");
    fp4 = fopen("expected_values_6tap.txt","w");

	if(fp3 == NULL) {
		printf("Error, Can't open file\n");
	} else {
        while ( fgets ( line, sizeof(line), fp3 ) != NULL )	{
            if (line[0] == 'n') {
                char *trunc = line + 5;
                fprintf(fp4, "%s", trunc);
                continue;
            }
            fprintf(fp4, "%s", line);
        }
    }
	fclose (fp3);
    fclose (fp4);

    printf("...finished truncating negative values to 4 digits...:\n");
}