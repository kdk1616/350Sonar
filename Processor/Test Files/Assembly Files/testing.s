.text
			# Initialize Valuesaddi $3, $0, 1	# r3 = 1
# read from pins 0-7
addi $28, $0, 0
addi $29, $29, 2047
jal main
add $8, $0, $2
j "6"
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
addi $8, $0, 0
addi $9, $0, 1
add $4, $0, $8
add $5, $0, $9
addi $29, $29, -1
sw $31, 0($29)
jal digitalWrite
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
addi $8, $0, 1
addi $9, $0, 1
add $4, $0, $8
add $5, $0, $9
addi $29, $29, -1
sw $31, 0($29)
jal digitalWrite
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
jal digitalWrite
lw $31, 0($29)
addi $29, $29, 1
addi $8, $0, 4
addi $9, $0, 1
add $4, $0, $8
add $5, $0, $9
addi $29, $29, -1
sw $31, 0($29)
jal pinMode
lw $31, 0($29)
addi $29, $29, 1
addi $8, $0, 4
addi $9, $0, 1
add $4, $0, $8
add $5, $0, $9
addi $29, $29, -1
sw $31, 0($29)
jal digitalWrite
lw $31, 0($29)
addi $29, $29, 1
addi $8, $0, 5
addi $9, $0, 1
add $4, $0, $8
add $5, $0, $9
addi $29, $29, -1
sw $31, 0($29)
jal pinMode
lw $31, 0($29)
addi $29, $29, 1
addi $8, $0, 0
addi $9, $0, 1
add $4, $0, $8
add $5, $0, $9
addi $29, $29, -1
sw $31, 0($29)
jal digitalWrite
lw $31, 0($29)
addi $29, $29, 1
addi $8, $0, 6
addi $9, $0, 1
add $4, $0, $8
add $5, $0, $9
addi $29, $29, -1
sw $31, 0($29)
jal pinMode
lw $31, 0($29)
addi $29, $29, 1
addi $8, $0, 0
addi $9, $0, 1
add $4, $0, $8
add $5, $0, $9
addi $29, $29, -1
sw $31, 0($29)
jal digitalWrite
lw $31, 0($29)
addi $29, $29, 1
addi $8, $0, 7
addi $9, $0, 1
add $4, $0, $8
add $5, $0, $9
addi $29, $29, -1
sw $31, 0($29)
jal pinMode
lw $31, 0($29)
addi $29, $29, 1
addi $8, $0, 0
addi $9, $0, 1
add $4, $0, $8
add $5, $0, $9
addi $29, $29, -1
sw $31, 0($29)
jal digitalWrite
lw $31, 0($29)
addi $29, $29, 1
"7":
jr $31
"6":
add $0, $0, $0
