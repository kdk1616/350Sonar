inline void pinMode(int pin, int mode){
    // 2^12 + 2^13 + pin num
    __asm__("sw (mode) 12288((pin))");
}
inline void digitalWrite(int pin, int level){
    // 2^13 + pin num
    __asm__("sw (level) 4096((pin))");
}

inline int digitalRead(int pin){
    // 2^12 + pin num
    __asm__("lw $return 4096((pin))");
}

inline int micros(){
    __asm__("addi $return $3 0");
}

void delayMicroseconds(int m){
    __asm__(
        "addi $8 $3 0"
        "sub $9 $3 $8"
        "delayMicrosLoopStart:"
        "blt (m) $9 delayMicrosEnd"
        "sub $9 $3 $8"
        "j delayMicrosLoopStart"
        "delayMicrosEnd:"
        "add $0 $0 $0"
    );
}

int pulseIn(int puslsePin, int pulseLevel, int pulseMaxTime){
    int clk = micros();
    while (digitalRead(puslsePin) != pulseLevel){
        int now = micros();
        if (pulseMaxTime < now - clk){ return 0; }
    }
    clk = micros();
    while (digitalRead(puslsePin) == pulseLevel){
        int now = micros();
        if (pulseMaxTime < now - clk){ return 0; }
    }
    return micros() - clk;
}

void send_protocol(int pin, int val){
    // delay time is 1042 us for 9600 baud rate
    int one_delay = 50;
    int zero_delay = 100;
    digitalWrite(pin, 1);
    delayMicroseconds(one_delay);
    digitalWrite(pin, 0);
    delayMicroseconds(one_delay);
    for (int i = 0; i < 32; i += 1){
        int v = val & 1;
        digitalWrite(pin, 1);
        if (v){
            delayMicroseconds(one_delay);
        }
        else {
            delayMicroseconds(zero_delay);
        }
        digitalWrite(pin, 0);
        delayMicroseconds(zero_delay);
        
        val >>= 1;
    }
    digitalWrite(pin, 0);
}
