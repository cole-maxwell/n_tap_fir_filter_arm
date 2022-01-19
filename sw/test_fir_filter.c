//==========================================================
//
// Source program for HPS-to-FPGA communication.
//
// Updated by Cole Maxwell on 02/18/2022
// Created by George Provelengios on 02/04/2017
//
//==========================================================

#define SIGNAL_SIZE 128

// Declare volatile pointers to I/O registers
// (volatile means that the locations will not be cached, even in registers)
volatile int* LED_PIO_ptr     = (int*) 0xFF200000; // LED_PIO base address
volatile int* DISPLAY_PIO_ptr = (int*) 0xFF200020; // DISPLAY_PIO base address
volatile int* OUTPUT_PIO_ptr  = (int*) 0xFF200030; // OUTPUT_PIO base address
volatile int* INPUT_PIO_ptr   = (int*) 0xFF200040; // INPUT_PIO base address
volatile int* KEY_PIO_ptr     = (int*) 0xFF200050; // KEY_PIO base address

const int signal_in[] = {
    0, 2, 4, 6, 8, 9, 9, 9, 9, 7, 5, 3, 1, -1, -3, -5,
    -7, -9, -9, -9, -9, -8, -6, -4, -2, 0, 2, 4, 6, 8, 9, 9,
    9, 8, 7, 5, 3, 1, -1, -3, -6, -7, -9, -9, -9, -9, -8, -6,
    -4, -2, 0, 2, 5, 7, 8, 9, 9, 9, 8, 7, 5, 3, 0, -1,
    -4, -6, -7, -9, -9, -9, -9, -8, -6, -4, -2, 0, 2, 5, 7, 8,
    9, 9, 9, 8, 7, 5, 3, 0, -1, -4, -6, -8, -9, -9, -9, -9,
    -8, -6, -4, -1, 0, 3, 5, 7, 8, 9, 9, 9, 8, 7, 5, 3,
    0, -1, -4, -6, -8, -9, -9, -9, -9, -8, -6, -4, -1, 0, 3, 5};

// Expected values for 4-Tap filter with coeff[] = { 2, 6, 5, 6};
// const int expected_values[] = {
    // 0, 4, 20, 46, 84, 120, 148, 165, 171, 167, 151, 125, 87, 49, 11, -27,
    // -65, -103, -137, -159, -171, -169, -159, -138, -106, -68, -30, 8, 46, 84, 120, 148,
    // 165, 169, 161, 146, 119, 87, 49, 11, -29, -71, -108, -143, -159, -171, -169, -159,
    // -138, -106, -68, -30, 10, 54, 95, 131, 154, 165, 169, 161, 146, 119, 85, 43,
    // 4, -41, -76, -114, -143, -159, -171, -169, -159, -138, -106, -68, -30, 10, 54, 95,
    // 131, 154, 165, 169, 161, 146, 119, 85, 43, 4, -41, -78, -120, -148, -165, -171,
    // -169, -159, -138, -104, -62, -23, 22, 59, 101, 131, 154, 165, 169, 161, 146, 119,
    // 85, 43, 4, -41, -78, -120, -148, -165, -171, -169, -159, -138, -104, -62, -23, 22};

// Expected values for 4-Tap filter with coeff[] = { 2, 7, 6, 7};
const int expected_values[] = {
    0, 4, 22, 52, 96, 138, 171, 191, 198, 194, 176, 146, 102, 58, 14, -30,
    -74, -118, -158, -184, -198, -196, -185, -161, -124, -80, -36, 8, 52, 96, 138, 171,
    191, 196, 187, 170, 139, 102, 58, 14, -32, -81, -124, -165, -184, -198, -196, -185,
    -161, -124, -80, -36, 10, 61, 109, 151, 178, 191, 196, 187, 170, 139, 100, 51,
    6, -46, -87, -131, -165, -184, -198, -196, -185, -161, -124, -80, -36, 10, 61, 109,
    151, 178, 191, 196, 187, 170, 139, 100, 51, 6, -46, -89, -138, -171, -191, -198,
    -196, -185, -161, -122, -73, -28, 24, 67, 116, 151, 178, 191, 196, 187, 170, 139,
    100, 51, 6, -46, -89, -138, -171, -191, -198, -196, -185, -161, -122, -73, -28, 24};

int fir_results[SIGNAL_SIZE];

void time_delay();
void print_array(const int [], int);
void send_word(int);
void send_signal_values();
void receive_fir_results();
void check_fir_results();

//==========================================================
// Main program
//==========================================================
int main()
{
    // Loop forever
    while(1)
    {
        // Reset the input buffer of the FIR wrapper
        if(*OUTPUT_PIO_ptr != 0x00000000)
            send_word(0x0000);

        // Reset the Hex displays
        *DISPLAY_PIO_ptr = 0;

        // Send to FIR filter the values of the signal
        send_signal_values();

        // Receive the outcomes of the FIR filter
        receive_fir_results();

        // Compare the output values of the
        // FIR module with the expected results
        check_fir_results();

        // Loop forever until a key is pressed down
        while(1)
        {
            // If KEY2 is pressed, first reset LEDs and HEX displays
            // and then break the loop to repeat the testing procedure
            if(*KEY_PIO_ptr == 0xB)
            {
                *LED_PIO_ptr     = 0;
                *DISPLAY_PIO_ptr = 0;
                time_delay();

                break;
            }
            else if(*KEY_PIO_ptr == 0xD)                // If KEY1 is pressed, print on the Hex
                print_array(fir_results, SIGNAL_SIZE);  // displays the outcomes of the FIR module
        }
    }

    return 0;
}

// Compare the output values of the
// FIR module with the expected results
void check_fir_results()
{
    int i    = 0;
    int pass = 1;

    // Read the results of the FIR module
    for(i = 0; i < SIGNAL_SIZE; ++i)
    {
        // If different assert to zero the flag pass
        if(fir_results[i] != expected_values[i])
            pass = 0;
    }

    // If the IFR module passes the test, turn on the LEDs{1,0}
    // otherwise turn on only the LED0 to signal the finish of the test
    *LED_PIO_ptr = pass ? 3 : 1;
}

// Monitor the input PIO register to
// receive the outcomes of the FIR filter
void receive_fir_results()
{
    // Initialize the prev_value with a value that
    // is not possible to be the first result of
    // the FIR module
    int prev_value = 0x0000;
    int index = 0;

    // Monitor the input PIO while the index is lees
    // than the size of the fir_results array
    while(index < SIGNAL_SIZE)
    {
        // If a new value comes store it into the resutls
        // array and increse the index counter
        if(prev_value != *INPUT_PIO_ptr)
        {
            // Ignore value 0x8001 which is used by the
            // FIR wrapper to reset the input PIO register
            if(*INPUT_PIO_ptr != 0x00008001)
            {
                // If the input value is less then 0 (16-bit) perform
                // a 32-bit sign extension before storing the new value
                // In addition, take into account that the value 0x00008000
                // is used by the FIR module to indicate the value 0x00000000
                if(*INPUT_PIO_ptr == 0x00008000)
                    fir_results[index] = 0;
                else if(*INPUT_PIO_ptr & 0x00008000)
                    fir_results[index] = *INPUT_PIO_ptr | 0xFFFF0000;
                else
                    fir_results[index] = *INPUT_PIO_ptr;

                ++index;
            }

            // Update the prev_value with the new
            // value of the input PIO register
            prev_value = *INPUT_PIO_ptr;
        }
    }
}

// Send the values of the signal to the FIR
// filter through the output PIO register
void send_signal_values()
{
    int i = 0;

    // Prepare the input buffer of the FIR wrapper
    send_word(0x8001);

    // Read the signal_in array and send one by one the
    // values of the signal to the FIR wrapper.
    for(i = 0; i < SIGNAL_SIZE; ++i)
    {
        // Send to Hex displays the transmitted word
        *DISPLAY_PIO_ptr = signal_in[i];

        // Send the ith value of the signal
        send_word(signal_in[i]);

        // Prepare the input buffer of the FIR wrapper
        send_word(0x8001);
    }

    // Reset the input buffer of the FIR wrapper
    send_word(0x0000);
}

// Send a single word to FIR wrapper, to ensure
// that has been sent it successfully, after a
// word transmission wait until the wrapper
// responds with an ack message
void send_word(int word)
{
    *OUTPUT_PIO_ptr = word;

    while(*INPUT_PIO_ptr == 0x00008001);

    while(*INPUT_PIO_ptr == 0x00000000);
}

// Print the values of the given array
// to the Hex displays of the board
void print_array(const int array[], int size)
{
    int i = 0;

    for(i = 0; i < size; ++i)
    {
        time_delay();
        *DISPLAY_PIO_ptr = array[i];
        *LED_PIO_ptr     = i;

        // If KEY1 is pressed, break the loop and return
        if(*KEY_PIO_ptr == 0xD)
        {
            while(*KEY_PIO_ptr == 0xD);
            break;
        }
    }
}

// Time delay function
void time_delay()
{
    volatile int delay_cnt;
    for(delay_cnt = 5000000; delay_cnt != 0; --delay_cnt);
}
