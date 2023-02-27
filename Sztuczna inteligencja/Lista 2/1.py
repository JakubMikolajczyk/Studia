import random

rowValue = []
colValue = []
rowLen = 0
colLen = 0


#  *********************************************************************************************************************


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
        v1 = calculateOpt(temp1, valTab[index])
        v2 = recursion(temp2, valTab, index + 1)

        val += v1 + v2

        if val < min:
            min = val

    return min


def optDistv3(data, valTab):
    tab = [0]
    sumVar = 0
    for i in range(0, len(data)):
        if data[i]:
            sumVar += 1
        tab.append(sumVar)

    return recursion(tab, valTab, 0)


#  *********************************************************************************************************************

def opt_dist(data, n):
    tab = [0]
    sum = 0
    for i in range(0, len(data)):
        if data[i]:
            sum += 1
        tab.append(sum)

    max = -1
    for i in range(n, len(data) + 1):
        if tab[i] - tab[i - n] > max:
            max = tab[i] - tab[i - n]

    return n - max + (sum - max)


def optDistv2(data, valTab):
    return recursionv2(data, valTab, 0)


def recursionv2(data, valTab, index):
    if index == len(valTab) - 1:
        return opt_dist(data, valTab[index])

    min = 20000
    for i in range(valTab[index], len(data)):
        val = 0
        if i != len(data) - 1:
            if data[i]:
                val += 1

        p1 = data[:i]
        p2 = data[(i + 1):]
        v1 = opt_dist(p1, valTab[index])
        v2 = recursionv2(p2, valTab, index + 1)
        val += v1 + v2
        if val < min:
            min = val

    return min

# **********************************************************************************************************************


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
        if data[i]:
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
        if v1 >= min:
            continue
        v2 = recursionv3(sumTab, i + 1, valTab, index + 1)
        val += v1 + v2
        if val == 0:
            return 0
        if val < min:
            min = val

    return min

# **********************************************************************************************************************

def optDist(data, valTab):
    opt = optDistv3(data, valTab)
    if opt > 15:
        print(data, valTab, opt)
    return opt

def genRandom():
    return [[random.choice([False, True]) for _ in range(colLen)] for _ in range(rowLen)]


def getCol(tab, index):
    # # print('index: ', index)
    # a = []
    # for i in range(rowLen):
    #     # print('i: ', i)
    #     a.append(tab[i][index])
    # return a
    return [tab[i][index] for i in range(rowLen)]


def checkChange(board, row, col):
    # print('row: ', row, 'col: ', col)
    before = optDist(board[row], rowValue[row]) + optDist(getCol(board, col), colValue[col])
    board[row][col] = not board[row][col]
    after = optDist(board[row], rowValue[row]) + optDist(getCol(board, col), colValue[col])
    board[row][col] = not board[row][col]
    return before - after


def genToChangeSet(board):
    toChange = set()

    for row in range(rowLen):
        if optDist(board[row], rowValue[row]) != 0:
            toChange.add(row)
    for col in range(colLen):
        if optDist(getCol(board, col), colValue[col]) != 0:
            toChange.add(col)
    return toChange


def nonogramSolver():
    board = genRandom()
    limit = 0

    toChange = genToChangeSet(board)

    while toChange:

        row = col = random.choice(tuple(toChange))
        # print(toChange)
        # print(row)

        # print(printer(board))
        # print()
        # print()
        toChange.remove(row)
        if row < rowLen and optDist(board[row], rowValue[row]) != 0:  # row changing
            minOpt = -2
            minCol = 0
            for col in range(colLen):
                val = checkChange(board, row, col)
                if val > minOpt:
                    minOpt = val
                    minCol = col
            board[row][minCol] = not board[row][minCol]
            if optDist(board[row], rowValue[row]) != 0:
                toChange.add(row)
            if optDist(getCol(board, minCol), colValue[minCol]) != 0:
                toChange.add(minCol)

        elif col < colLen and optDist(getCol(board, col), colValue[col]):  # col changing
            minOpt = -2
            minRow = 0
            for row in range(rowLen):
                val = checkChange(board, row, col)
                if val > minOpt:
                    minOpt = val
                    minRow = row
            board[minRow][col] = not board[minRow][col]
            if optDist(board[minRow], rowValue[minRow]) != 0:
                toChange.add(minRow)
            if optDist(getCol(board, col), colValue[col]) != 0:
                toChange.add(col)

        limit += 1
        if limit > (rowLen * colLen * 9):
            limit = 0
            board = genRandom()
            toChange = genToChangeSet(board)
    return board


def printer(board):
    ans = ''
    for row in board:
        for col in row:
            if col:
                ans += '#'
            else:
                ans += '.'
        ans += '\n'
    return ans


input = open('zad_input.txt', 'r')
output = open('zad_output.txt', 'w')

length = input.readline().split(' ')

rowLen = int(length[0])
colLen = int(length[1])

for row in range(rowLen):
    line = input.readline().split(' ')
    rowValue.append([])
    for i in line:
        rowValue[row].append(int(i))

for col in range(colLen):
    line = input.readline().split(' ')
    colValue.append([])
    for i in line:
        colValue[col].append(int(i))

ans = printer(nonogramSolver())
print(ans)
output.write(ans)
