addi $28, $0, 1
addi $29, $29, 2047
addi $8, $0, 0
sw $8, 0($0)
jal main
add $8, $0, $2
j "55"
delayMicroseconds:
addi $8, $3, 0
sub $9, $3, $8
delayMicrosLoopStart:
blt $4, $9, "1"
sub $9, $3, $8
j delayMicrosLoopStart
"1":
jr $31
pulseIn:
addi $8, $3, 0
"7":
lw $9, 4096($4)
bne $9, $5, "8"
j "9"
"8":
addi $10, $3, 0
sub $11, $10, $8
blt $6, $11, "12"
j "7"
"12":
addi $11, $0, 0
add $2, $0, $11
j "4"
"9":
addi $12, $3, 0
add $8, $0, $12
"15":
lw $12, 4096($4)
bne $12, $5, "17"
addi $13, $3, 0
sub $14, $13, $8
blt $6, $14, "21"
j "15"
"21":
addi $14, $0, 0
add $2, $0, $14
j "4"
"17":
addi $15, $3, 0
sub $15, $15, $8
add $2, $0, $15
"4":
jr $31
send_protocol:
addi $8, $0, 50
addi $9, $0, 100
add $10, $0, $4
addi $11, $0, 1
sw $11, 4096($4)
add $4, $0, $8
addi $29, $29, -5
sw $31, 0($29)
sw $8, 1($29)
sw $10, 2($29)
sw $5, 3($29)
sw $9, 4($29)
jal delayMicroseconds
lw $31, 0($29)
lw $8, 1($29)
lw $10, 2($29)
lw $5, 3($29)
lw $9, 4($29)
addi $29, $29, 5
add $11, $0, $10
addi $12, $0, 0
sw $12, 4096($10)
add $4, $0, $8
addi $29, $29, -5
sw $31, 0($29)
sw $8, 1($29)
sw $11, 2($29)
sw $5, 3($29)
sw $9, 4($29)
jal delayMicroseconds
lw $31, 0($29)
lw $8, 1($29)
lw $11, 2($29)
lw $5, 3($29)
lw $9, 4($29)
addi $29, $29, 5
addi $10, $0, 0
"29":
addi $12, $0, 32
blt $10, $12, "30"
j "32"
"30":
addi $12, $0, 1
and $12, $5, $12
add $13, $0, $11
addi $14, $0, 1
sw $14, 4096($11)
bne $12, $0, "34"
add $4, $0, $9
addi $29, $29, -7
sw $31, 0($29)
sw $10, 1($29)
sw $8, 2($29)
sw $13, 3($29)
sw $12, 4($29)
sw $5, 5($29)
sw $9, 6($29)
jal delayMicroseconds
lw $31, 0($29)
lw $10, 1($29)
lw $8, 2($29)
lw $13, 3($29)
lw $12, 4($29)
lw $5, 5($29)
lw $9, 6($29)
addi $29, $29, 7
j "35"
"34":
add $4, $0, $8
addi $29, $29, -7
sw $31, 0($29)
sw $10, 1($29)
sw $8, 2($29)
sw $13, 3($29)
sw $12, 4($29)
sw $5, 5($29)
sw $9, 6($29)
jal delayMicroseconds
lw $31, 0($29)
lw $10, 1($29)
lw $8, 2($29)
lw $13, 3($29)
lw $12, 4($29)
lw $5, 5($29)
lw $9, 6($29)
addi $29, $29, 7
"35":
add $11, $0, $13
addi $14, $0, 0
sw $14, 4096($13)
add $4, $0, $9
addi $29, $29, -7
sw $31, 0($29)
sw $10, 1($29)
sw $8, 2($29)
sw $11, 3($29)
sw $12, 4($29)
sw $5, 5($29)
sw $9, 6($29)
jal delayMicroseconds
lw $31, 0($29)
lw $10, 1($29)
lw $8, 2($29)
lw $11, 3($29)
lw $12, 4($29)
lw $5, 5($29)
lw $9, 6($29)
addi $29, $29, 7
sra $5, $5, 1
addi $10, $10, 1
j "29"
"32":
add $13, $0, $11
addi $14, $0, 0
sw $14, 4096($11)
jr $31
stepMotor:
addi $8, $0, 37740
addi $9, $0, 3
lw $10, 0($0)
and $9, $10, $9
addi $11, $0, 0
"41":
blt $11, $9, "42"
j "44"
"42":
sra $12, $8, 4
add $8, $0, $12
addi $11, $11, 1
j "41"
"44":
addi $12, $0, 0
addi $13, $0, 1
and $13, $8, $13
sw $13, 4096($12)
addi $13, $0, 1
sra $12, $8, 1
addi $14, $0, 1
and $14, $12, $14
sw $14, 4096($13)
addi $14, $0, 2
sra $13, $8, 2
addi $12, $0, 1
and $12, $13, $12
sw $12, 4096($14)
addi $12, $0, 3
sra $14, $8, 3
addi $13, $0, 1
and $13, $14, $13
sw $13, 4096($12)
addi $13, $10, 1
addi $12, $0, 3
and $12, $13, $12
add $10, $0, $12
sw $10, 0($0)
jr $31
us_sensor_dist:
addi $8, $0, 4
addi $9, $0, 5
addi $10, $0, 0
sw $10, 4096($8)
addi $10, $0, 2
add $4, $0, $10
addi $29, $29, -3
sw $31, 0($29)
sw $9, 1($29)
sw $8, 2($29)
jal delayMicroseconds
lw $31, 0($29)
lw $9, 1($29)
lw $8, 2($29)
addi $29, $29, 3
addi $10, $0, 1
sw $10, 4096($8)
addi $10, $0, 10
add $4, $0, $10
addi $29, $29, -3
sw $31, 0($29)
sw $9, 1($29)
sw $8, 2($29)
jal delayMicroseconds
lw $31, 0($29)
lw $9, 1($29)
lw $8, 2($29)
addi $29, $29, 3
addi $10, $0, 0
sw $10, 4096($8)
addi $10, $0, 1
addi $11, $0, 35000
add $4, $0, $9
add $5, $0, $10
add $6, $0, $11
addi $29, $29, -3
sw $31, 0($29)
sw $9, 1($29)
sw $8, 2($29)
jal pulseIn
lw $31, 0($29)
lw $9, 1($29)
lw $8, 2($29)
addi $29, $29, 3
add $10, $0, $2
add $2, $0, $10
jr $31
main:
addi $8, $0, 0
addi $9, $0, 1
sw $9, 12288($8)
addi $9, $0, 1
addi $8, $0, 1
sw $8, 12288($9)
addi $8, $0, 2
addi $9, $0, 1
sw $9, 12288($8)
addi $9, $0, 3
addi $8, $0, 1
sw $8, 12288($9)
addi $8, $0, 4
addi $9, $0, 1
sw $9, 12288($8)
addi $9, $0, 5
addi $8, $0, 0
sw $8, 12288($9)
addi $8, $0, 7
addi $9, $0, 1
sw $9, 12288($8)
addi $9, $0, 8
addi $8, $0, 1
sw $8, 12288($9)
addi $8, $0, 9
addi $9, $0, 1
sw $9, 12288($8)
addi $9, $0, 10
addi $8, $0, 1
sw $8, 12288($9)
addi $8, $0, 11
addi $9, $0, 1
sw $9, 12288($8)
addi $9, $0, 0
addi $8, $0, 0
sw $8, 4096($9)
addi $8, $0, 1
addi $9, $0, 0
sw $9, 4096($8)
addi $9, $0, 2
addi $8, $0, 0
sw $8, 4096($9)
addi $8, $0, 3
addi $9, $0, 0
sw $9, 4096($8)
addi $9, $0, 8
addi $8, $0, 0
sw $8, 4096($9)
addi $8, $0, 9
addi $9, $0, 0
sw $9, 4096($8)
addi $9, $0, 10
addi $8, $0, 0
sw $8, 4096($9)
addi $8, $0, 11
addi $9, $0, 0
sw $9, 4096($8)
addi $9, $0, 2000
addi $8, $0, 10000
addi $10, $0, 0
"77":
addi $11, $0, 1
bne $11, $0, "78"
j "56"
"78":
addi $12, $0, 0
"80":
addi $13, $0, 64
blt $12, $13, "81"
j "83"
"81":
addi $29, $29, -6
sw $31, 0($29)
sw $11, 1($29)
sw $10, 2($29)
sw $9, 3($29)
sw $12, 4($29)
sw $8, 5($29)
jal stepMotor
lw $31, 0($29)
lw $11, 1($29)
lw $10, 2($29)
lw $9, 3($29)
lw $12, 4($29)
lw $8, 5($29)
addi $29, $29, 6
add $4, $0, $9
addi $29, $29, -6
sw $31, 0($29)
sw $11, 1($29)
sw $10, 2($29)
sw $9, 3($29)
sw $12, 4($29)
sw $8, 5($29)
jal delayMicroseconds
lw $31, 0($29)
lw $11, 1($29)
lw $10, 2($29)
lw $9, 3($29)
lw $12, 4($29)
lw $8, 5($29)
addi $29, $29, 6
addi $12, $12, 1
j "80"
"83":
addi $29, $29, -6
sw $31, 0($29)
sw $11, 1($29)
sw $10, 2($29)
sw $9, 3($29)
sw $12, 4($29)
sw $8, 5($29)
jal us_sensor_dist
lw $31, 0($29)
lw $11, 1($29)
lw $10, 2($29)
lw $9, 3($29)
lw $12, 4($29)
lw $8, 5($29)
addi $29, $29, 6
add $13, $0, $2
addi $14, $10, 1
addi $15, $0, 31
and $15, $14, $15
add $10, $0, $15
addi $15, $0, 7
add $4, $0, $15
add $5, $0, $13
addi $29, $29, -7
sw $31, 0($29)
sw $11, 1($29)
sw $10, 2($29)
sw $9, 3($29)
sw $13, 4($29)
sw $12, 5($29)
sw $8, 6($29)
jal send_protocol
lw $31, 0($29)
lw $11, 1($29)
lw $10, 2($29)
lw $9, 3($29)
lw $13, 4($29)
lw $12, 5($29)
lw $8, 6($29)
addi $29, $29, 7
addi $14, $0, 8
addi $15, $0, 1
sw $15, 4096($14)
addi $15, $0, 9
addi $14, $0, 0
sw $14, 4096($15)
addi $14, $0, 10
addi $15, $0, 1
sw $15, 4096($14)
addi $15, $0, 11
addi $14, $0, 0
sw $14, 4096($15)
add $4, $0, $8
addi $29, $29, -7
sw $31, 0($29)
sw $11, 1($29)
sw $10, 2($29)
sw $9, 3($29)
sw $13, 4($29)
sw $12, 5($29)
sw $8, 6($29)
jal delayMicroseconds
lw $31, 0($29)
lw $11, 1($29)
lw $10, 2($29)
lw $9, 3($29)
lw $13, 4($29)
lw $12, 5($29)
lw $8, 6($29)
addi $29, $29, 7
j "77"
"56":
jr $31
"55":
add $0, $0, $0
