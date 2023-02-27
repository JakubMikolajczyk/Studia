def calculateOpt(sumTab, val):
    maxVar = -200000
    for i in range(val, len(sumTab)):
        if sumTab[i] - sumTab[i - val] > maxVar:
            maxVar = sumTab[i] - sumTab[i - val]
    return val - maxVar + (sumTab[len(sumTab) - 1] - sumTab[0] - maxVar)


def recursion(sumTab, valTab, index):
    if index == len(valTab) - 1:
        return calculateOpt(sumTab, valTab[index])

    min = 20000000
    n = valTab[index]
    for i in range(n, len(sumTab) - 1):  # sprawdzanie wolnej przestrzeni do tyłu, małe ryzyko wyskoczenia za indeks
        val = 0
        if i != len(sumTab) - 1:  # w przod lepiej warunek konca lepszym straznikiem czy nie dodawac spacji?
            val += sumTab[i + 1] - sumTab[i]
        temp1 = sumTab[:(i + 1)]
        temp2 = sumTab[(i + 1):]

        # print(temp1, temp2)
        v1 = calculateOpt(sumTab[:(i + 1)], valTab[index])
        v2 = recursion(sumTab[(i + 1):], valTab, index + 1)

        # val += calculateOpt(sumTab[:(i)], valTab[index]) + recursion(sumTab[(i):], valTab, index + 1)
        val += v1 + v2
        if val < min:
            min = val

    return min


def optDist(data, valTab):
    tab = [0]
    sumVar = 0
    for i in range(0, len(data)):
        if data[i] == '1':
            sumVar += 1
        tab.append(sumVar)

    return recursion(tab, valTab, 0)


def opt_dist(data, n):
    tab = [0]
    sum = 0
    for i in range(0, len(data)):
        if data[i] == '1':
            sum += 1
        tab.append(sum)

    max = -2000
    for i in range(n, len(data) + 1):
        if tab[i] - tab[i - n] > max:
            max = tab[i] - tab[i - n]

    return n - max + (sum - max)


#  *********************************************************************************************************************



def optDistv2(data, valTab):
    return recursionv2(data, valTab, 0)


def recursionv2(data, valTab, index):
    if index == len(valTab) - 1:
        return opt_dist(data, valTab[index])

    min = 20000
    for i in range(valTab[index], len(data)):
        val = 0
        if i != len(data) - 1:
            if data[i] == '1':
                val += 1

        p1 = data[:i]
        p2 = data[(i + 1):]
        v1 = opt_dist(p1, valTab[index])
        v2 = recursionv2(p2, valTab, index + 1)
        val += v1 + v2
        if val < min:
            min = val

    return min

#  *********************************************************************************************************************


def calculateOptv3(sumTab, val, p, k):
    maxVar = -200000
    for i in range(val + p, k):
        if sumTab[i] - sumTab[i - val] > maxVar:
            maxVar = sumTab[i] - sumTab[i - val]
    return val - maxVar + (sumTab[k - 1] - sumTab[p] - maxVar)


def optDistv3(data, valTab):
    tab = [0]
    sumVar = 0
    for i in range(0, len(data)):
        if data[i] == '1':
            sumVar += 1
        tab.append(sumVar)
    return recursionv3(tab, 0, valTab, 0)


def recursionv3(sumTab, sep, valTab, index):
    if index == len(valTab) - 1:
        return calculateOptv3(sumTab, valTab[index], sep, len(sumTab))

    min = 20000000
    n = valTab[index]
    for i in range(n + sep, len(sumTab) - 1):
        val = 0
        if i != len(sumTab) - 1:
            val += sumTab[i + 1] - sumTab[i]

        v1 = calculateOptv3(sumTab, valTab[index], sep,  i + 1)
        if v1 > min:
            continue
        v2 = recursionv3(sumTab, i + 1, valTab, index + 1)
        val += v1 + v2
        if val == 0:
            return 0
        if val < min:
            min = val

    return min

# *********************************************************************************************************************

print(optDistv3('1011111', [1, 5]), optDist('1011111', [1, 5]))
print(optDistv3('1101111', [2, 4]), optDist('1101111', [2, 4]))
print(optDistv3('11011101', [2, 3, 1]), optDist('11011101', [2, 3, 1]))
print(optDistv3('0000000', [1, 5]), optDist('00000£00', [1, 5]))
print(optDistv3('11111', [2, 2]), optDist('11111', [2, 2]))
print(optDistv3('11111', [2, 1]), optDist('11111', [2, 1]))
print(optDistv3('11111', [1, 1]), optDist('11111', [1, 1]))
print(optDistv3('1101101110', [5, 3]))
