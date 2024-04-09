.text
			# Initialize Valuesaddi $3, $0, 1	# r3 = 1
addi $28, $0, 9
addi $29, $29, 2047
addi $8, $0, 0
sw $8, 0($0)
addi $9, $0, 1
sw $9, 1($0)
addi $10, $0, 2
sw $10, 2($0)
addi $11, $0, 3
sw $11, 3($0)
addi $12, $0, 0
sw $8, 4($0)
sw $9, 5($0)
sw $10, 6($0)
sw $11, 7($0)
sw $12, 8($0)
jal main
add $8, $0, $2
j "16"
pinMode:
addi $10, $0, 12288
add $10, $10, $4
sw $5, 0($10)
"1":
jr $31
digitalWrite:
addi $10, $0, 4096
add $10, $10, $4
sw $5, 0($10)
"4":
jr $31
digitalRead:
addi $9, $0, 4096
add $9, $9, $4
lw $2, 0($9)
"7":
jr $31
stepMotor:
addi $9, $0, 22185
addi $10, $0, 3
and $10, $4, $10
addi $11, $0, 0
"12":
blt $11, $4, "13"
j "15"
"13":
sra $12, $9, 4
add $9, $0, $12
"14":
addi $11, $11, 1
j "12"
"15":
addi $12, $0, 1
and $12, $9, $12
sra $13, $9, 1
addi $14, $0, 1
and $14, $13, $14
sra $13, $9, 2
addi $15, $0, 1
and $15, $13, $15
sra $13, $9, 3
addi $16, $0, 1
and $16, $13, $16
sw $12, 4096($0)
sw $14, 4097($0)
sw $15, 4098($0)
sw $16, 4099($0)
"10":
jr $31
main:
addi $8, $0, 0
addi $9, $0, 1
add $4, $0, $8
add $5, $0, $9
addi $29, $29, -1
sw $31, 0($29)
jal pinMode
lw $31, 0($29)
addi $29, $29, 1
addi $8, $0, 1
addi $9, $0, 1
add $4, $0, $8
add $5, $0, $9
addi $29, $29, -1
sw $31, 0($29)
jal pinMode
lw $31, 0($29)
addi $29, $29, 1
addi $8, $0, 2
addi $9, $0, 1
add $4, $0, $8
add $5, $0, $9
addi $29, $29, -1
sw $31, 0($29)
jal pinMode
lw $31, 0($29)
addi $29, $29, 1
addi $8, $0, 3
addi $9, $0, 1
add $4, $0, $8
add $5, $0, $9
addi $29, $29, -1
sw $31, 0($29)
jal pinMode
lw $31, 0($29)
addi $29, $29, 1
addi $8, $0, 0
addi $9, $0, 0
add $4, $0, $8
add $5, $0, $9
addi $29, $29, -1
sw $31, 0($29)
jal digitalWrite
lw $31, 0($29)
addi $29, $29, 1
addi $8, $0, 1
addi $9, $0, 0
add $4, $0, $8
add $5, $0, $9
addi $29, $29, -1
sw $31, 0($29)
jal digitalWrite
lw $31, 0($29)
addi $29, $29, 1
addi $8, $0, 2
addi $9, $0, 0
add $4, $0, $8
add $5, $0, $9
addi $29, $29, -1
sw $31, 0($29)
jal digitalWrite
lw $31, 0($29)
addi $29, $29, 1
addi $8, $0, 3
addi $9, $0, 0
add $4, $0, $8
add $5, $0, $9
addi $29, $29, -1
sw $31, 0($29)
jal digitalWrite
lw $31, 0($29)
addi $29, $29, 1
addi $8, $0, 0
"19":
addi $9, $0, 1
bne $9, $0, "20"
j "17"
"20":
add $4, $0, $8
addi $29, $29, -2
sw $31, 0($29)
sw $9, 1($29)
jal stepMotor
lw $31, 0($29)
lw $8, 1($29)
addi $29, $29, 2
addi $9, $10, 1
add $10, $0, $9
j "19"
"17":
jr $31
"16":
add $0, $0, $0
