import itertools
import random

import numpy as np


def init():
    d = dict()

    for i in range(1, 71):
        for j in range(1, 71):
            d[(i, j)] = set()
            for square in range(1, 25):
                if i + square -1 <= 70 and j + square -1 <= 70:
                    d[(i, j)].add(square)
    return d


class Board:

    def __init__(self):
        self.tab = [[0 for _ in range(71)] for _ in range(71)]
        self.fields = []
        self.squares = [i for i in range(1, 25)]
        self.boardHistory = []
        self.fieldsHistory = [{(0, 0)}]
        self.squaresHistory = []
        self.availableMoves = init()

        for i in range(1, 71):
            for j in range(1, 71):
                self.fields.append((i, j))

    def terminal(self):
        return len(self.fields) < 800 or len(self.squares) == 0 or len(self.availableMoves) == 0

    def copy(self):
        new = Board()
        new.fields = self.fields.copy()
        new.squares = self.squares.copy()
        new.moves = self.availableMoves.copy()
        new.tab = [i[:] for i in self.tab]
        return new

    def undo(self):
        self.squaresHistory = self.squaresHistory.pop()
        self.tab = self.boardHistory.pop()
        self.fieldsHistory = self.fieldsHistory.pop()

    def heuristic(self):
        return len(self.fields)

    def moves(self):
        return self.availableMoves

    def randomMove(self):
        return random.choice(tuple(self.availableMoves))

    def doMove(self, square, pos):

        self.availableMoves.remove((square, pos))

        x, y = pos

        for i in range(x, x + square):
            for j in range(y, y + square):
                self.tab[i][j] = square
                self.fields.remove((i, j))
        return self


def backTracking(game):
    pass

test = init()
print(test)

# game1 = Board()
# game1.doMove(24, (1, 1))
# game1.doMove(23, (24, 24))
# game1.doMove(22, (23 + 24, 23 + 24))
#
# bestRes = 40000000
# bestBoard = game1
# for _ in range(10):
#     moves = 0
#     game = game1.copy()
#     while True and moves < 50:
#         s, p = game.randomMove()
#         game = game.doMove(s, p)
#         # print(s, p)
#         moves += 1
#         if game.heuristic() < bestRes:
#             bestBoard = game.copy()
#             bestRes = game.heuristic()
#         if game.terminal():
#             break
#
# for i in range(1, 71):
#     for j in range(1, 71):
#         if bestBoard.tab[i][j] == 0:
#             print('.', end=' ')
#         else:
#             print(chr(bestBoard.tab[i][j] + 64), end=' ')
#     print()
# print(bestBoard.heuristic())
