# Processor
## Ethan Horowitz (EJ55)

## Description of Design

The processor (so far) fulfills the entire ISA, inserts noops for div operations and exceptions, and is able to detect some data hazards.

It uses a wallace tree for multiplication and a booth divider. Jumps are calculated at the execute stage, and when the ALU produces an exception the register and the status register are both written to.

## Bypassing

## Stalling

## Optimizations

## Bugs

None that I know of

## Running / Testing
`find . -name "*.v" > FileList.txt`

`iverilog -o proctb -c FileList.txt -s processor_tb`

`iverilog -o proc -c FileList.txt -s Wrapper_tb -P Wrapper_tb.FILE=\"addi_basic\"`

`assembler/asm -o processor_tests.mem "Test Files/Assembly Files/testing.s"`

all together:
`assembler/asm -o processor_tests.mem "Test Files/Assembly Files/testing.s" & iverilog -o proctb -c FileList.txt -s processor_tb`

## Operations I would like to implement:
- xor
- logical not
- logical and
- logical or
- slt (set less than)
- seq
