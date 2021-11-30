def main(number):
  print(bin(number))
  ones_count = 0
  swichies = 0
  length = 0
  len_ones = 0
  len_zeros = 0
  for i in bin(number)[2:]:
    if i == '1':
      ones_count += 1
  for i in range(255):
    if ( ( number & ( 1 << i) ) >> i ) ^ ( ( number & ( 1 << ( i + 1 ) ) ) >> ( i + 1 ) ):
      swichies += 1
  for i in range(256):
    if ( ( number & ( 1 << i) ) >> i ):
      length += 1
      if length > len_ones:
        len_ones = length
    else:
      length = 0
  length = 0
  for i in range(256):
    if ( ( number & ( 1 << i) ) >> i ) == 0:
      length += 1
      if length > len_zeros:
        len_zeros = length
    else:
      length = 0
  print("Количество единиц: ", ones_count)
  print("Количество переключений: ", swichies)
  print("Максимальная длина единиц: ", len_ones)
  print("Максимальная длина нулей: ", len_zeros)


if __name__ == '__main__':
  main(0x0e02089908c450c01e3f55ea62e0a7c8ad28077cf08821a03be0131fffa43ff7)