.text
			# Initialize Valuesaddi $3, $0, 1	# r3 = 1
# read from pins 0-7
addi $28, $0, 2
addi $29, $29, 2047
addi $8, $0, 0
addi $9, $0, 0
sw $8, 0($0)
sw $9, 1($0)
jal main
add $8, $0, $2
j "23"
malloc:
add $2, $28, $4
add $28, $28, $4
"1":
jr $31
pinMode:
addi $10, $0, 24576
add $10, $10, $4
sw $5, 0($10)
"4":
jr $31
digitalWrite:
addi $10, $0, 8192
add $10, $10, $4
sw $5, 0($10)
"7":
jr $31
digitalRead:
addi $9, $0, 8192
add $9, $9, $4
lw $2, 0($9)
"10":
jr $31
wait:
addi $8, $0, 0
"15":
addi $9, $0, 1000
blt $8, $9, "16"
j "13"
"16":
addi $9, $0, 0
"19":
addi $10, $0, 1000
blt $9, $10, "21"
j "17"
"21":
addi $9, $9, 1
j "19"
"17":
addi $8, $8, 1
j "15"
"13":
jr $31
main:
addi $8, $0, 1
addi $9, $0, 1
add $4, $0, $8
add $5, $0, $9
addi $29, $29, -1
sw $31, 0($29)
jal pinMode
lw $31, 0($29)
addi $29, $29, 1
"26":
addi $8, $0, 1
bne $8, $0, "27"
j "24"
"27":
addi $9, $0, 1
addi $10, $0, 1
add $4, $0, $9
add $5, $0, $10
addi $29, $29, -2
sw $31, 0($29)
sw $8, 1($29)
jal digitalWrite
lw $31, 0($29)
lw $8, 1($29)
addi $29, $29, 2
addi $29, $29, -2
sw $31, 0($29)
sw $8, 1($29)
jal wait
lw $31, 0($29)
lw $8, 1($29)
addi $29, $29, 2
addi $9, $0, 1
addi $10, $0, 0
add $4, $0, $9
add $5, $0, $10
addi $29, $29, -2
sw $31, 0($29)
sw $8, 1($29)
jal digitalWrite
lw $31, 0($29)
lw $8, 1($29)
addi $29, $29, 2
addi $29, $29, -2
sw $31, 0($29)
sw $8, 1($29)
jal wait
lw $31, 0($29)
lw $8, 1($29)
addi $29, $29, 2
j "26"
"24":
jr $31
"23":
add $0, $0, $0