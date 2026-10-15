import random

rowValue = []
colValue = []
rowLen = 0
colLen = 0


def optDist(data, n):
    tab = [0]
    sumVar = 0
    for i in range(0, len(data)):
        if data[i]:
            sumVar += 1
        tab.append(sumVar)

    maxVar = -1
    for i in range(n, len(data) + 1):
        if tab[i] - tab[i - n] > maxVar:
            maxVar = tab[i] - tab[i - n]

    return n - maxVar + (tab[len(tab) - 1] - maxVar)


def genRandom():
    return [[random.choice([False, True]) for _ in range(rowLen)] for _ in range(colLen)]


def getCol(tab, index):
    return [tab[i][index] for i in range(len(tab))]


def checkChange(board, row, col):
    before = optDist(board[row], rowValue[row]) + optDist(getCol(board, col), colValue[col])
    board[row][col] = not board[row][col]
    after = optDist(board[row], rowValue[row]) + optDist(getCol(board, col), colValue[col])
    board[row][col] = not board[row][col]
    return before - after


def genToChangeSet(board):
    toChange = set()

    for row in range(rowLen):
        if optDist(board, rowValue[row]) != 0:
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
        toChange.remove(row)
        if optDist(board[row], rowValue[row]) != 0:  # row changing
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

        elif optDist(getCol(board, col), colValue[col]):    # col changing
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
        if limit > 10000:
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

input = open('zad5_input.txt', 'r')
output = open('zad5_output.txt', 'w')

length = input.readline().split(' ')

rowLen = int(length[0])
colLen = int(length[1])

for row in range(rowLen):
    rowValue.append(int(input.readline()))

for col in range(colLen):
    colValue.append(int(input.readline()))

ans = printer(nonogramSolver())
print(ans)
output.write(ans)

