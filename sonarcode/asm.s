.text
			# Initialize Valuesaddi $3, $0, 1	# r3 = 1
addi $29 $0 2047
sw $0 1($0)        # stepper step = 0($0) 

jal main

main:
    addi $4 $0 0
    addi $5 $0 1
    jal pinMode   # pinMode(0, OUTPUT)
    addi $4 $0 1
    jal pinMode   # pinMode(1, OUTPUT)
    addi $4 $0 2
    jal pinMode   # pinMode(2, OUTPUT)
    addi $4 $0 3
    jal pinMode   # pinMode(3, OUTPUT)
    addi $4 $0 4
    jal pinMode   # pinMode(4, OUTPUT)
    addi $4 $0 5
    addi $5 $0 0
    jal pinMode   # pinMode(5, INPUT)
    addi $4 $0 8
    addi $5 $0 1
    jal pinMode   # pinMode(8, OUTPUT)
    addi $4 $0 9
    jal pinMode   # pinMode(9, OUTPUT)
    addi $4 $0 10
    jal pinMode   # pinMode(10, OUTPUT)
    addi $4 $0 11
    jal pinMode   # pinMode(11, OUTPUT)

    addi $8 $0 0
    addi $1 $0 10
    mul $8 $8 $1    # delay time = $8 = 100000
    
    mainLoop:
        addi $sp $sp -1
        sw $8 0($sp)
        jal readUSSensor
        lw $8 0($sp)
        addi $sp $sp 1
        
        addi $9 $0 1000
        addi $10 $0 2000
        addi $11 $0 3000

        sgt $9 $2 $9        # $9 = (distance > 1000)
        sgt $10 $2 $10      # $10 = (distance > 2000)
        sgt $11 $2 $11      # $11 = (distance > 3000)
        sgt $12 $2 $0       # $12 = (distance > 0)

        addi $4 $0 8
        addi $5 $12 0
        jal digitalWrite    # digitalWrite(8, distance > 0)

        addi $4 $0 9
        addi $5 $9 0
        jal digitalWrite    # digitalWrite(9, distance > 1000)

        addi $4 $0 10
        addi $5 $10 0
        jal digitalWrite    # digitalWrite(10, distance > 2000)

        addi $4 $0 11
        addi $5 $11 0
        jal digitalWrite    # digitalWrite(11, distance > 3000)

        addi $sp $sp -1
        sw $8 0($sp)
        jal stepMotor
        lw $8 0($sp)
        
        addi $4 $8 0
        sw $8 0($sp)
        jal delayMicros
        lw $8 0($sp)
        addi $sp $sp 1

        j mainLoop

pinMode:
    sw $5 12288($4)
    jr $31
digitalWrite:
    sw $5 4096($4)
    jr $31
digitalRead:
    lw $2 4096($4)
    jr $31
delayMicros:
    addi $8 $3 0        # $8 = clock start
    sub $9 $3 $8        # $9 = clock - start
    delayMicrosLoopStart: 
    blt $4 $9 delayMicrosEnd       # if us < clock dif, go to end (if clock_dif >= us)
    sub $9 $3 $8
    j delayMicrosLoopStart
    delayMicrosEnd:
    jr $31
pulseIn:
    addi $sp $sp -1
    sw $31 0($sp)

    addi $8 $4 0    # $8 = pin
    addi $9 $5 0    # $9 = level
    addi $10 $6 0   # $10 = timeout
 
    addi $11 $3 0   # $11 = clock
    pulseInStart:
    addi $4 $8 0
    jal digitalRead
    pulseWait: bne $2 $9 pulseWaitBody  # if digitalRead(pin) != level, go to pulseWaitBody
    j pulseWaitEnd
    pulseWaitBody:
       sub $12 $3 $11  # $12 = clock - start
       blt $10 $12 pulseInTimeout      # if timeout < clock - start, go to pulseInTimeout
       j pulseInStart
    pulseWaitEnd:
   
    addi $11 $3 0   # $11 = clock
 
    pulseReadStart:
    addi $4 $8 0
    jal digitalRead
    bne $2 $9 pulseReadEnd  # if digitalRead(pin) != level, go to end
       sub $12 $3 $11  # $12 = clock - start
       blt $10 $12 pulseInTimeout      # if timeout < clock - start, go to pulseInTimeout
       j pulseReadStart

    pulseReadEnd:
    lw $31 0($sp)
    addi $sp $sp 1

    sub $2 $3 $11
    jr $31
   
    pulseInTimeout:
    lw $31 0($sp)
    addi $sp $sp 1
    
    addi $2 $0 0
    jr $31
readUSSensor:
    addi $sp $sp -1
    sw $31 0($sp)
    addi $8 $0 4    # $8 = trigger
    addi $9 $0 5    # $9 = echo
  
    addi $4 $8 0
    addi $5 $0 0
    jal digitalWrite    # digitalWrite(trigger, LOW)
  
    addi $sp $sp -2
    sw $8 0($sp)
    sw $9 1($sp)
    addi $4 $0 2
    jal delayMicros     # delayMicros(2)
    lw $8 0($sp)
    lw $9 1($sp)
    addi $sp $sp 2
  
    addi $4 $8 0
    addi $5 $0 1
    jal digitalWrite    # digitalWrite(trigger, HIGH)
  
    addi $sp $sp -2
    sw $8 0($sp)
    sw $9 1($sp)
    addi $4 $0 10
    jal delayMicros     # delayMicros(10)
    lw $8 0($sp)
    lw $9 1($sp)
    addi $sp $sp 2
  
    addi $4 $8 0
    addi $5 $0 0
    jal digitalWrite    # digitalWrite(trigger, LOW)
  
    addi $4 $9 0
    addi $5 $0 1
    addi $6 $0 23539
    jal pulseIn        # pulseIn(echo, HIGH, 23539)
    addi $8 $0 1
    div $2 $2 $8
    lw $31 0($sp)
    addi $sp $sp 1
    jr $31
stepMotor:
    addi $sp $sp -1
    sw $31 0($sp)

    lw $8 1($0)         # $8 = stepper step
    addi $9 $0 37740    # $9 = seq
    addi $10 $0 0       # $10 = temp i
    stepMotor_rshift_loop:
    blt $10 $8 stepMotor_rshift_body
    j stepMotor_rshift_end
        stepMotor_rshift_body:
        sra $9 $9 4
        addi $10 $10 1
        j stepMotor_rshift_loop
    stepMotor_rshift_end:
    addi $10 $0 1       # $10 = 1

    and $11 $9 $10
    sw $11 4096($0)   # digitalWrite(0, seq & 1)

    sra $11 $9 1
    and $11 $11 $10      
    sw $11 4097($0)      # digitalWrite(1, (seq >> 1) & 1)

    sra $11 $9 2
    and $11 $11 $10 
    sw $11 4098($0)     # digitalWrite(1, (seq >> 2) & 1)

    sra $11 $9 3
    and $11 $11 $10
    sw $11 4099($0)      # digitalWrite(1, (seq >> 3) & 1)

    addi $10 $0 3
    addi $8 $8 1
    and $8 $8 $10
    sw $8 1($0)         # stepper step = (stepper step + 1) % 4

    lw $31 0($sp)
    addi $sp $sp 1
    jr $31
