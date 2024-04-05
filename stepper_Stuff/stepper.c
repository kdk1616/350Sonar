
#define HIGH 1
#define LOW 0
#define INPUT 0
#define OUTPUT 1



int coilPins[4] = {7, 8, 9, 10}; // Coil pins connected to In1, In2, In3, In4
int numSteps = 4; // Number of steps in the sequence

// Define the sequence of steps for the stepper motor
// const byte stepSequence4[4] = {
//   B1100, // Step A: AB
//   B0110, // Step B: BC
//   B0011, // Step C: CD
//   B1001  // Step D: DA
// };

int stepSequence = 37740; // See above


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
void digitalRead(int pin){
    int addr = 4096 + pin; // 2^12 + pin num
    __asm__(
        "lw $v0 0((addr))"
    );
}

void wait(int ms){
    for (int i = 0; i < ms; i = i + 1){
    }
}



void setup() {
  // Set coil pins as outputs
    pinMode(0,OUTPUT);
    pinMode(1,OUTPUT);
    pinMode(2,OUTPUT);
    pinMode(3,OUTPUT);
}


void stepMotor() {
  // Output the step sequence
  int currentSeq = stepSequence;
  int ms_1 = 50000;
  int wait_time = 100*ms_1;

  for (int i = 0; i < 15; i += 1) {
    int outBit = stepSequence & 1;
    int pinNum = i & 3;
    digitalWrite(pinNum, outBit);
    stepSequence = stepSequence >> 1;
    wait(wait_time);
  }

  // Move to the next step
}

int main(){

   setup();//init IO

   int ms_1 = 50000;
   int wait_time = 1000*ms_1;

   while(1) {
        stepMotor();
        wait(wait_time);
   }
}
