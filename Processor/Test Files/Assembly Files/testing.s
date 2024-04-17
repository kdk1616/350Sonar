.text
			# Initialize Valuesaddi $3, $0, 1	# r3 = 1
addi $29 $0 2047

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
    
    mainLoop:
        jal readUSSensor
        bne $2 $0 dispHigh
            addi $4 $0 0
            addi $5 $0 0
            jal digitalWrite
            j mainLoop
        dispHigh:
            addi $4 $0 0
            addi $5 $0 1
            jal digitalWrite
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