

def ones(number: int):
	return bin(number).count('1')

def main():
	with open("./mem.hex", 'w') as f:
		for i in range(256):
			f.write("{:01x}\n".format(ones(i)))


if __name__ == '__main__':
	main()