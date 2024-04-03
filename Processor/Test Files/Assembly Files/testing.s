.text
			# Initialize Valuesaddi $3, $0, 1	# r3 = 1
# read from pins 0-7
addi $1 $0 1
sw $1 12288($0)
addi $1 $0 1
sw $1 4096($0)

sw $1 12289($0)
sw $1 4097($0)

sw $1 12290($0)
sw $0 4098($0)