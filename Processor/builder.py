bin = '''
00101001000010000000000000000100
'''

# 00101 00001 00001 00000000000000001
# addi   $r1   $r1    1


file = open('processor_tests.mem', 'w')

chars = bin.strip().split('\n')

while len(chars) < 4096:
    chars.append('0'*32)
    
text = '\n'.join(chars)
file.write(text)


file.close()
