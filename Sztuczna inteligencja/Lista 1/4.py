def opt_dist(data, n):
    tab = [0]
    sum = 0
    for i in range(0, len(data)):
        if data[i] == '1':
            sum += 1
        tab.append(sum)

    max = -1
    for i in range(n, len(data) + 1):
        if tab[i] - tab[i - n] > max:
            max = tab[i] - tab[i - n]

    return n - max + (sum - max)


# f = open('zad4_input.txt', 'r')
# ans = open('zad4_output.txt', 'w')
# for i in f.readlines():
#     temp = i.replace('\n', '').split(' ')
#     ans.write(str(opt_dist(temp[0], int(temp[1]))) + '\n')
#
# f.close()
# ans.close()
