

def ones(number: int):
	return bin(number).count('1')

def ones_len(number: int):
	length = 0
	max_len = 0
	max_end = 0
	max_start = 0
	for i in range(8):
		if ( number >> i ) & 0x01:
			length += 1
			if length > max_len:
				max_len = length
		else:
			length = 0;
	for i in range(8):
		if ( number >> ( 7 - i ) & 0x01):
			max_end += 1
		else:
			break
	for i in range(8):
		if ( number >> i & 0x01):
			max_start += 1
		else:
			break
	return max_len, max_end, max_start

def main():
	with open("./mem.hex", 'w') as f:
		for i in range(256):
			f.write("{:01x}\n".format(ones(i)))
	with open("./mem_len.hex", 'w') as f:
		for i in range(256):
			tmp = ones_len(i)
			print("{:08b}:\tMax {} End {} Start {}".format(i, tmp[0], tmp[1], tmp[2]))
			f.write("{:03x}\n".format(tmp[0] << 8 | tmp[1] << 4 | tmp[2]))


if __name__ == '__main__':
	main()