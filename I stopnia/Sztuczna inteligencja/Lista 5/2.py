import itertools
import random

import numpy as np


def init():
    d = dict()

    for square in range(1, 25):
        d[square] = set()

        # for i in range(1, )


class Board:

    def __init__(self):
        self.tab = [[0 for _ in range(71)] for _ in range(71)]
        self.fields = []
        self.squares = [i for i in range(1, 25)]
        self.boardHistory = []
        self.fieldsHistory = [{(0, 0)}]
        self.squaresHistory = []
        self.moves = set()

        for i in range(1, 71):
            for j in range(1, 71):
                self.fields.append((i, j))

    def terminal(self):
        if len(self.fields) < 800:
            return True

        if len(self.squares) == 0:
            return True
        return False

    def copy(self):
        new = Board()
        new.fields = self.fields.copy()
        new.squares = self.squares.copy()
        new.moves = self.moves.copy()
        new.tab = [i[:] for i in self.tab]
        return new

    def undo(self):
        self.squaresHistory = self.squaresHistory.pop()
        self.tab = self.boardHistory.pop()
        self.fieldsHistory = self.fieldsHistory.pop()

    def heuristic(self):
        return len(self.fields)

    def randomMove(self):
        return random.choice(self.squares), random.choice(tuple(self.fields))

    def doMove(self, square, pos):
        if square not in self.squares:
            return self

        x, y = pos
        if x + square > 70 or y + square > 70:
            return self

        # self.squaresHistory.append(self.squares.copy())
        # print("Histoty: ", self.fieldsHistory)
        # self.fieldsHistory.append(self.fields.copy())
        # # print()
        # # print('***********')
        # # print()
        # self.boardHistory.append([i[:] for i in self.tab])
        #
        temp = self.copy()
        self.squares.remove(square)

        for i in range(x, x + square):
            for j in range(y, y + square):
                if (i, j) not in self.fields:
                    # self.undo()
                    return temp
                else:
                    self.tab[i][j] = square
                    self.fields.remove((i, j))
        return self


def backTracking(game):
    pass


# bestRes = 40000000
# bestBoard = None
# for _ in range(100):
#     moves = 0
#     game = Board()
#     while True and moves < 100:
#         s, p = game.randomMove()
#         game = game.doMove(s, p)
#         # print(s, p)
#         moves += 1
#         if game.heuristic() < bestRes:
#             bestBoard = game.copy()
#             bestRes = game.heuristic()
#         if game.terminal():
#             break

game1 = Board()
game1.doMove(24, (0, 0))
game1.doMove(23, (24, 24))
game1.doMove(22, (23 + 24, 23 + 24))

bestRes = 40000000
bestBoard = game1
for _ in range(10):
    moves = 0
    game = game1.copy()
    while True and moves < 50:
        s, p = game.randomMove()
        game = game.doMove(s, p)
        # print(s, p)
        moves += 1
        if game.heuristic() < bestRes:
            bestBoard = game.copy()
            bestRes = game.heuristic()
        if game.terminal():
            break

for i in range(1, 71):
    for j in range(1, 71):
        if bestBoard.tab[i][j] == 0:
            print('.', end='  ')
        else:
            print(chr(bestBoard.tab[i][j] + 64), end='  ')
    print()
print(bestBoard.heuristic())
