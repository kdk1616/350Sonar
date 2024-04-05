
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

int stepSequence = 50745; // See above




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

void wait(){
    for (int i = 0; i < 1000; i = i + 1){
        for (int j = 0; j < 1000; j = j + 1){

        }
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

  for (int i = 0; i < 15; i += 1) {

    int outBit = stepSequence & 1;
    int pinNum = i & 3;
    digitalWrite(pinNum, outBit);
    wait();
  }

  // Move to the next step
}

int main(){

   setup();//init IO

   while(1) {
        stepMotor();
        wait();
   }
}
