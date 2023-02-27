import time


def make_board(str):
    l = str.split(' ')
    if l[0] == 'black':
        turn = False
    else:
        turn = True

    wK = strToCord(l[1])
    wR = strToCord(l[2])
    bK = strToCord(l[3])
    return Board(wK, wR, bK, turn)


def strToCord(str):
    return ord(str[0:1]) - 96, int(str[1:2])


# true = black
# false = white

class Board:
    def __init__(self, wK, wR, bK, turn):
        self.blackKing = bK
        self.whiteKing = wK
        self.whiteRook = wR
        self.turn = turn

    def inBound(self, p):
        (x, y) = p
        return 1 <= x <= 8 and 1 <= y <= 8

    def getKingFields(self, p):
        ans = []
        move = ((1, 1), (-1, 1), (1, -1), (-1, -1), (1, 0), (-1, 0), (0, 1), (0, -1))
        for (x, y) in move:
            (a, b) = p
            new = (a + x, b + y)
            if self.inBound(new):
                ans.append(new)
        return ans

    def getRookFields(self):
        ans = []
        moves = ((1, 0), (-1, 0), (0, 1), (0, -1))
        for (x, y) in moves:
            for i in range(1, 8):
                (a, b) = self.whiteRook
                new = (a + x * i, b + y * i)
                if not self.inBound(new) or new == self.whiteKing:
                    break
                else:
                    ans.append(new)
        return ans

    def genBlackMoves(self):
        bKing = self.getKingFields(self.blackKing)
        wKing = self.getKingFields(self.whiteKing)
        wRook = self.getRookFields()
        wKing.extend(wRook)
        for i in wKing:
            if i in bKing:
                bKing.remove(i)
        boards = []
        for i in bKing:
            boards.append(Board(self.whiteKing, self.whiteRook, i, True))
        return boards

    def genWhiteMoves(self):
        bKing = self.getKingFields(self.blackKing)
        wKing = self.getKingFields(self.whiteKing)
        wRook = self.getRookFields()

        for i in bKing:
            if i in wKing:
                wKing.remove(i)

        if self.whiteRook in wKing:
            wKing.remove(self.whiteRook)

        if self.whiteKing in wRook:
            wRook.remove(self.whiteKing)

        boards = []

        for i in wRook:
            boards.append(Board(self.whiteKing, i, self.blackKing, False))

        for i in wKing:
            boards.append(Board(i, self.whiteRook, self.blackKing, False))

        return boards

    def genMoves(self):
        if self.turn:
            return self.genWhiteMoves()
        else:
            return self.genBlackMoves()

    def check(self):
        wRook = self.getRookFields()
        return self.blackKing in wRook

    def getTuple(self):
        return (self.whiteKing, self.whiteRook, self.blackKing)

    def printTuple(self, tup):
        tab = ['', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
        return tab[tup[0]] + str(tup[1])

    def printer(self):
        tab = ['', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
        s = self.printTuple(self.whiteKing) + ' '
        s += self.printTuple(self.whiteRook) + ' '
        s += self.printTuple(self.blackKing)
        return s

    def printChange(self, prevBoard):

        if self.whiteKing != prevBoard.whiteKing:
            return self.printTuple(prevBoard.whiteKing) + self.printTuple(self.whiteKing)

        if self.whiteRook != prevBoard.whiteRook:
            return self.printTuple(prevBoard.whiteRook) + self.printTuple(self.whiteRook)

        if self.blackKing != prevBoard.blackKing:
            return self.printTuple(prevBoard.blackKing) + self.printTuple(self.blackKing)


visited = set()


def BFS(board: Board):
    que = [[board]]
    visited.add(board.getTuple())
    while len(que) != 0:
        path = que.pop(0)
        last = path[-1]  # ostatnia plansza z niej generujemy kolejne
        moves = last.genMoves()
        # last.printer()
        if len(moves) == 0 and last.check():  # brak ruchów i szach => szachmat
            return path

        for m in moves:
            if m.getTuple() not in visited:
                new_path = list(path)
                new_path.append(m)
                visited.add(m.getTuple())
                que.append(new_path)


# input = open('zad1_input.txt', 'r')
# output = open('zad1_output.txt', 'w')
#
# for i in input.read().splitlines():
#     start_time = time.time()
#     output.write(str(len(BFS(make_board(i))) - 1) + '\n')
#     print("--- %s seconds ---" % (time.time() - start_time))
#
# input.close()
# output.close()

moving_player = 'white'
white_king = 'e3'
white_rook = 'h5'
black_king = 'e1'

ans = BFS(make_board(' '.join([moving_player, white_king, white_rook, black_king])))

s = ''

for i in range(1, len(ans)):
    s = s + ans[i].printChange(ans[i - 1]) + ' '

print(s)
