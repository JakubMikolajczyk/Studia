import copy


class Type:
    Black = 1
    X = 0
    Q = -1


class Cell:

    def __init__(self):
        self.cellVal = None
        self.perm = None
        self.sum = None

    def init(self, n, cellVal):
        self.cellVal = cellVal
        self.perm = []
        self.sum = [0] * n
        self.recursion([0] * n, n, 0, cellVal)
        for perm in self.perm:
            for j, val in enumerate(perm):
                self.sum[j] += val

    def __len__(self):
        return len(self.perm)

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


class Board:
    rowPerm = []
    colPerm = []
    queX = set()
    queBlack = set()
    board = None

    def __deepcopy__(self, memodict={}):
        new = Board()
        new.rowPerm = copy.deepcopy(self.rowPerm)
        new.colPerm = copy.deepcopy(self.colPerm)
        new.board = copy.deepcopy(self.board)

        return new

    def init(self):
        self.board = [[Type.Q for _ in range(rowLen)] for _ in range(colLen)]

        for col in range(rowLen):
            cell = Cell()
            cell.init(colLen, colValue[col])
            self.colPerm.append(cell)
            for row in cell.genX():
                self.queX.add((row, col))
            for row in cell.genBlack():
                self.queBlack.add((row, col))

        for row in range(colLen):
            cell = Cell()
            cell.init(rowLen, rowValue[row])
            self.rowPerm.append(cell)
            for col in cell.genX():
                self.queX.add((row, col))
            for col in cell.genBlack():
                self.queBlack.add((row, col))

    def change(self, row, col, type):
        self.rowPerm[row].newPermanent(col, type)
        self.colPerm[col].newPermanent(row, type)

        for c in self.rowPerm[row].genX():
            if self.board[row][c] == Type.Q:
                self.queX.add((row, c))

        for r in self.colPerm[col].genX():
            if self.board[r][col] == Type.Q:
                self.queX.add((r, col))

        for c in self.rowPerm[row].genBlack():
            if self.board[row][c] == Type.Q:
                self.queBlack.add((row, c))

        for r in self.colPerm[col].genBlack():
            if self.board[r][col] == Type.Q:
                self.queBlack.add((r, col))

    def guessing(self):
        while len(self.queX) != 0 or len(self.queBlack) != 0:

            if len(self.queX) != 0:
                (row, col) = self.queX.pop()
                self.board[row][col] = Type.X
                self.change(row, col, Type.X)

            if len(self.queBlack) != 0:
                (row, col) = self.queBlack.pop()
                self.board[row][col] = Type.Black
                self.change(row, col, Type.Black)

    def printer(self):
        ans = ''
        for row in self.board:
            for col in row:

                if col == Type.Black:
                    ans += '#'
                if col == Type.Q:
                    ans += '?'
                if col == Type.X:
                    ans += '.'
            ans += '\n'
        return ans

    def isEnd(self):
        for row in self.rowPerm:
            if len(row) != 1:
                return False

        for col in self.colPerm:
            if len(col) != 1:
                return False
        return True

    def isValid(self):
        for row in self.rowPerm:
            if len(row) == 0:
                return False

        for col in self.colPerm:
            if len(col) == 0:
                return False
        return True

    def setField(self, row, col, type):
        self.board[row][col] = type
        self.change(row, col, type)

    def isUnset(self, row, col):
        return self.board[row][col] == Type.Q

    def solv(self):
        self.guessing()
        return backtracking(self)


def next(row, col):
    row += 1
    if row == rowLen:
        row = 0
        col += 1
    return row, col


def isEnd(row, col):
    return row >= colLen or col >= rowLen


def backtracking(board: Board):
    (row, col) = (0, 0)
    stack = []
    lastType = Type.Black

    while not board.isEnd():
        (row, col) = next(row, col)
        # print(board.printer())
        # print()
        # print(row, col)
        if isEnd(row, col) or not board.isValid():
            lastType = Type.X
            while lastType == Type.X:
                (board, row, col, lastType) = stack.pop()
            lastType = Type.X

        if board.isUnset(row, col):
            temp = copy.deepcopy(board)
            stack.append((temp, row, col, lastType))
            board.setField(row, col, lastType)
            board.guessing()
            if lastType == Type.X:
                lastType = Type.Black

    return board


rowValue = []
colValue = []


input = open('zad_input.txt', 'r')
output = open('zad_output.txt', 'w')

length = input.readline().split(' ')

colLen = int(length[0])  # długość kolumny
rowLen = int(length[1])  # długość wiersza

for row1 in range(colLen):
    line = input.readline().split(' ')
    rowValue.append([])
    for i in line:
        rowValue[row1].append(int(i))

for col1 in range(rowLen):
    line = input.readline().split(' ')
    colValue.append([])
    for i in line:
        colValue[col1].append(int(i))

board1 = Board()
board1.init()
board1.guessing()
board1 = backtracking(board1)
ans = board1.printer()
print(ans)
output.write(ans)
