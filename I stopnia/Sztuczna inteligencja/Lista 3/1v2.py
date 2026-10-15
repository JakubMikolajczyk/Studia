class Type:
    Black = 1
    X = 0
    Q = -1


class Cell:

    def __init__(self, n, cellVal):
        self.cellVal = cellVal
        self.perm = []
        self.sum = [0] * n
        self.recursion([0] * n, n, 0, cellVal)
        for perm in self.perm:
            for j, val in enumerate(perm):
                self.sum[j] += val

    def recursion(self, tab, n, index, cellVal):
        if len(cellVal) == 0:
            self.perm.append(tab)
            return

        for i in range(index, n - sum(cellVal) - len(cellVal) + 2):
            temp = tab.copy()
            for x in range(cellVal[0]):
                temp[i + x] = 1
            self.recursion(temp, n, i + cellVal[0] + 1, cellVal[1:])

    def genBlack(self):
        ans = []
        for i in range(len(self.sum)):
            if self.sum[i] == len(self.perm):
                ans.append(i)
        return ans

    def genX(self):
        ans = []
        for i in range(len(self.sum)):
            if self.sum[i] == 0:
                ans.append(i)
        return ans

    def newPermanent(self, index, type):
        for perm in self.perm.copy():
            if perm[index] != type:
                self.perm.remove(perm)
                for j, val in enumerate(perm):
                    self.sum[j] -= val


def change(board, row, col, type):
    rowPerm[row].newPermanent(col, type)
    colPerm[col].newPermanent(row, type)

    for c in rowPerm[row].genX():
        if board[row][c] == Type.Q:
            queX.add((row, c))

    for r in colPerm[col].genX():
        if board[r][col] == Type.Q:
            queX.add((r, col))

    for c in rowPerm[row].genBlack():
        if board[row][c] == Type.Q:
            queBlack.add((row, c))

    for r in colPerm[col].genBlack():
        if board[r][col] == Type.Q:
            queBlack.add((r, col))


def nonogramSolver():
    board = [[Type.Q for _ in range(rowLen)] for _ in range(colLen)]

    for col in range(rowLen):
        cell = Cell(colLen, colValue[col])
        colPerm.append(cell)
        for row in cell.genX():
            queX.add((row, col))
        for row in cell.genBlack():
            queBlack.add((row, col))


    for row in range(colLen):
        cell = Cell(rowLen, rowValue[row])
        rowPerm.append(cell)
        for col in cell.genX():
            queX.add((row, col))
        for col in cell.genBlack():
            queBlack.add((row, col))

    while len(queX) != 0 or len(queBlack) != 0:
        if len(queX) != 0:
            (row, col) = queX.pop()
            board[row][col] = Type.X
            change(board, row, col, Type.X)
        if len(queBlack) != 0:
            (row, col) = queBlack.pop()
            board[row][col] = Type.Black
            change(board, row, col, Type.Black)

    return board


def printer(board):
    ans = ''
    for row in board:
        for col in row:
            if col == Type.Black:
                ans += '#'
            if col == Type.Q:
                ans += '?'
            if col == Type.X:
                ans += '.'
        ans += '\n'
    return ans


rowValue = []
colValue = []

rowPerm = []
colPerm = []
queX = set()
queBlack = set()

input = open('zad_input.txt', 'r')
output = open('zad_output.txt', 'w')

length = input.readline().split(' ')

colLen = int(length[0])  # długość kolumny
rowLen = int(length[1])  # długość wiersza

for row in range(colLen):
    line = input.readline().split(' ')
    rowValue.append([])
    for i in line:
        rowValue[row].append(int(i))

for col in range(rowLen):
    line = input.readline().split(' ')
    colValue.append([])
    for i in line:
        colValue[col].append(int(i))

ans = printer(nonogramSolver())
print(ans)
output.write(ans)
