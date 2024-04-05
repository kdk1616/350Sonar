
#define HIGH 1
#define LOW 0
#define INPUT 0
#define OUTPUT 1
#define PIN0_SET_OUTPUT __asm__( "addi $1 $1 1""sw $1 12288($0)");
#define PIN1_SET_OUTPUT __asm__( "addi $1 $1 1""sw $1 12289($0)");
#define PIN2_SET_OUTPUT __asm__( "addi $1 $1 1""sw $1 12290($0)");
#define PIN3_SET_OUTPUT __asm__( "addi $1 $1 1""sw $1 12291($0)");

#define PIN0_SET_HIGH __asm__( "addi $1 $1 0""sw $1 4096($0)");
#define PIN0_SET_LOW __asm__( "sw $0 4096($0)");
#define PIN1_SET_HIGH __asm__( "addi $1 $1 0""sw $1 4097($0)");
#define PIN1_SET_LOW __asm__( "sw $0 4097($0)");
#define PIN2_SET_HIGH __asm__( "addi $1 $1 0""sw $1 4098($0)");
#define PIN2_SET_LOW __asm__( "sw $0 4098($0)");
#define PIN3_SET_HIGH __asm__( "addi $1 $1 0""sw $1 4099($0)");
#define PIN3_SET_LOW __asm__( "sw $0 4099($0)");

// int i = 3;

// PIN0_SET_OUTPUT
// PIN0_SET_HIGH

// PIN1_SET_OUTPUT
// PIN1_SET_HIGH

// PIN2_SET_OUTPUT
// PIN2_SET_HIGH

// PIN3_SET_OUTPUT
// PIN3_SET_HIGH

// int numSteps = 4; // Number of steps in the sequence
// Define the sequence of steps for the stepper motor
// const byte stepSequence4[4] = {
//   B1100, // Step A: AB
//   B0110, // Step B: BC
//   B0011, // Step C: CD
//   B1001  // Step D: DA
// };
// or?
// const byte stepSequence4[4] = {
//   B1010, // Step A: AB
//   B0110, // Step B: BC
//   B0101, // Step C: CD
//   B1001  // Step D: DA
// };

// int stepSequence = 37740; // See above
// int pins[4] = {0, 1, 2, 3};


void pinMode(int pin, int mode){
    int addr = 12288 + pin; // 2^12 + 2^13 + pin num
    __asm__(
        "sw (mode) 0((addr))"
    );
}
void digitalWrite(int pin, int level){
    int addr = 4096 + pin; // 2^13 + pin num
    __asm__(
        "sw (level) 0((addr))"
    );
}

pinMode(0, 1);
digitalWrite(0, 1);
pinMode(1, 1);
digitalWrite(1, 1);
pinMode(2, 1);
digitalWrite(2, 1);
pinMode(3, 1);
digitalWrite(3, 1);

// void digitalRead(int pin){
//     int addr = 4096 + pin; // 2^12 + pin num
//     __asm__(
//         "lw $v0 0((addr))"
//     );
// }

// void setup() {
//   // Set coil pins as outputs
//     pinMode(0,OUTPUT);
//     pinMode(1,OUTPUT);
//     pinMode(2,OUTPUT);
//     pinMode(3,OUTPUT);

//     digitalWrite(0,LOW);
//     digitalWrite(1,LOW);
//     digitalWrite(2,LOW);
//     digitalWrite(3,LOW);
// }

// void wait(int cycles){
//     for (int i = 0; i < cycles; i += 1){}
// }

// void stepMotor(int step, int* pins) {
//   // Output the step sequence
//     int mod4 = step & 3;
//     if (mod4 == 0) {
//         digitalWrite(pins[0], HIGH);
//         digitalWrite(pins[1], LOW);
//         digitalWrite(pins[2], LOW);
//         digitalWrite(pins[3], HIGH);
//     } else if (mod4 == 1) {
//         digitalWrite(pins[0], LOW);
//         digitalWrite(pins[1], HIGH);
//         digitalWrite(pins[2], LOW);
//         digitalWrite(pins[3], HIGH);
//     } else if (mod4 == 2) {
//         digitalWrite(pins[0], LOW);
//         digitalWrite(pins[1], HIGH);
//         digitalWrite(pins[2], HIGH);
//         digitalWrite(pins[3], LOW);
//     } else {
//         digitalWrite(pins[0], HIGH);
//         digitalWrite(pins[1], LOW);
//         digitalWrite(pins[2], HIGH);
//         digitalWrite(pins[3], LOW);
//     }
// }

// int main(){

//    setup(); //init IO

//    int ms_1 = 50000;
//    int wait_time = 100*ms_1;
//    int step = 0;

//    while(1) {
//         stepMotor(step, pins);
//         step += 1;
//         digitalWrite(3, HIGH);
//         wait(wait_time);
//    }
// }
