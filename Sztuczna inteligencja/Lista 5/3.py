#!/usr/bin/env python
# -*- coding: UTF-8 -*-
'''
Losowy agent do Dżungli
'''

import random
import string
import sys
import chess
import numpy as np


def piecesValue(board):
    white = 0
    black = 0
    dic = {
        'K': 10000,
        'Q': 9,
        'B': 3,
        'N': 3,
        'R': 5,
        'P': 1
    }
    for i in str(board):
        for j in i:
            if j in string.ascii_lowercase:
                black += dic[j.upper()]
            if j in string.ascii_uppercase:
                white += dic[j]

    return white, black


def getMovesLen(board, color):
    if board.turn == color:
        return board.legal_moves.count()
    else:
        board.push(chess.Move.null())
        l = board.legal_moves.count()
        board.pop()
        return l


def heuristic(board, alpha):
    out = board.outcome()
    if out is None:
        whiteValue, blackValue = piecesValue(board)
        whiteMoves = getMovesLen(board, False)
        blackMoves = getMovesLen(board, True)
        return blackValue - whiteValue \
               + alpha * (whiteMoves - blackMoves)
    if out.winner is None:
        return np.inf
    if out.winner:
        return -np.inf
    else:
        return np.inf


def maxValue(game, depth, alpha, beta):
    if depth == 0 or game.outcome() is not None:
        return heuristic(game, 1)
    val = -10000000
    for move in game.legal_moves:
        game.push(move)
        val = max(val, minValue(game, depth - 1, alpha, beta))
        game.pop()
        if val >= beta:
            return val
        alpha = max(alpha, val)
    return val


def minValue(game, depth, alpha, beta):
    if depth == 0 or game.outcome is not None:
        return heuristic(game, 1)
    val = 10000000
    for move in game.legal_moves:
        game.push(move)
        val = min(val, maxValue(game, depth - 1, alpha, beta))
        game.pop()
        if val <= alpha:
            return val
        beta = min(alpha, val)
    return val


def alphabetaPlayer(game, color, depth):
    if color:
        bestMove = None
        bestVal = np.inf
        for move in game.legal_moves:
            game.push(move)
            v = maxValue(game, depth, -np.inf, np.inf)
            game.pop()
            if v < bestVal:
                # print(bestVal)
                bestVal = v
                bestMove = move
    else:
        bestMove = None
        bestVal = -np.inf
        for move in game.legal_moves:
            game.push(move)
            v = minValue(game, depth, -np.inf, np.inf)
            game.pop()
            if v > bestVal:
                # print(bestVal)
                bestVal = v
                bestMove = move
    return str(bestMove)


class Chess:
    def __init__(self):
        self.board = chess.Board()

    def update(self, uci_move):
        try:
            move = chess.Move.from_uci(uci_move)
        except ValueError:
            raise WrongMove

        if move not in self.board.legal_moves:
            raise WrongMove

        self.board.push(move)
        out = self.board.outcome()
        if out is None:
            return None
        if out.winner is None:
            return 0
        if out.winner:
            return -1
        else:
            return +1

    def moves(self):
        return [str(m) for m in self.board.legal_moves]

    def draw(self):
        print(self.board)


score = 0
b = 0
c = 0
r = 0

for i in range(10):
    move = 0
    p = 0
    game = Chess()
    whiteMoves = 0
    numMoves = 0
    while True and whiteMoves <= 100:
        if p == 0:
            # moves = game.moves()
            # move = random.choice(moves)
            move = alphabetaPlayer(game.board, True, 4)

            whiteMoves += 1
        else:
            # moves = game.moves()
            # move = random.choice(moves)
            move = alphabetaPlayer(game.board, False, 2)

        p = 1 - p
        numMoves += 1
        out = game.update(move)
        if out is not None or whiteMoves == 100:
            if out == -1:
                print("Biały wygrał")
                b += 1
            elif out == 1:
                print('Czarny wygrał')
                c += 1
            else:
                print('Remis')
                r += 1
            print(game.board)
            print()
            print()
            break

print("b:", b)
print('c: ', c)
print('r: ', r)