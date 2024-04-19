#define HIGH 1
#define LOW 0
#define INPUT 0
#define OUTPUT 1

inline void pinMode(int pin, int mode){
    int addr = 12288 + pin; // 2^12 + 2^13 + pin num
    __asm__(
            "sw (mode) 0((addr))"
            );
}
inline void digitalWrite(int pin, int level){
    int addr = 4096 + pin; // 2^13 + pin num
    __asm__(
            "sw (level) 0((addr))"
            );
}

inline void digitalRead(int pin){
    int addr = 4096 + pin; // 2^12 + pin num
    __asm__(
            "lw $v0 0((addr))"
            );
}

int _stepper_step = 0;
void stepMotor(int pin0, int pin1, int pin2, int pin3) {
    // const byte stepSequence4[4] = {
    //   B1100, // Step A: AB
    //   B0110, // Step B: BC
    //   B0011, // Step C: CD
    //   B1001  // Step D: DA
    // };
    int seq = 37740;
    int mod4 = _stepper_step & 3;
    for (int i = 0; i < mod4; i += 1){
        seq = seq >> 4;
    }
    digitalWrite(pin0,seq & 1);
    digitalWrite(pin1,(seq >> 1) & 1);
    digitalWrite(pin2,(seq >> 2) & 1);
    digitalWrite(pin3,(seq >> 3) & 1);
    _stepper_step += 1;
}

int main(){

    pinMode(0,OUTPUT);
    pinMode(1,OUTPUT);
    pinMode(2,OUTPUT);
    pinMode(3,OUTPUT);

    digitalWrite(0,LOW);
    digitalWrite(1,LOW);
    digitalWrite(2,LOW);
    digitalWrite(3,LOW);

    int step = 0;
    int clk = 0;

    while(1) {
        stepMotor(0, 1, 2, 3);
        step += 1;
    }
}
