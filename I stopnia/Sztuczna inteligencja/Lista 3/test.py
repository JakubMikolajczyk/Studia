tab = [[1,2,3], [4,5,6], [7,8,9]]

a = [x[:] for x in tab]

tab[0][0]= 2341
print(a)
