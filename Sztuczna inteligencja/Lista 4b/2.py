#!/usr/bin/env python
# -*- coding: UTF-8 -*-
'''
Losowy agent do Dżungli
'''

import string
import chess
import chess.engine
import numpy as np

K = 100
engine = chess.engine.SimpleEngine.popen_uci('/opt/homebrew/bin/stockfish')


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


def whitePlayerMove(board, alpha):
    bestMove = None
    bestVal = np.inf
    for move in board.legal_moves:
        board.push(move)
        val = heuristic(board, alpha)
        board.pop()
        if val <= bestVal:
            bestVal = val
            bestMove = move
    return bestMove


def blackPlayerMove(board, alpha):
    bestMove = None
    bestVal = -np.inf
    for move in board.legal_moves:
        board.push(move)
        val = heuristic(board, alpha)
        board.pop()
        if val >= bestVal:
            bestVal = val
            bestMove = move
    return bestMove


class Player:
    alpha = 0
    matchHistory = []

    def __init__(self, id, alpha):
        self.id = id
        self.alpha = alpha
        self.score = {-1: 0, 0: 0, 1: 0}
        self.matchHistory = [0 for _ in range(100)]

    def result(self, player, res):
        self.score[res] += 1
        self.matchHistory[player.id] += res

    def __gt__(self, other):
        if self.score[1] != other.score[1]:
            return self.score[1] < other.score[1]

        if self.score[0] != other.score[0]:
            return self.score[0] < other.score[0]

        if self.score[-1] != other.score[-1]:
            return self.score[-1] < other.score[-1]

        return self.matchHistory[other.id] == 1

    def __str__(self):
        s = 'PlayerId: ' + str(self.id) + '\nStatistic:' + str(self.score[1]) + '-' + str(self.score[0]) + '-' + str(
            self.score[-1]) + '\nAlpha' + str(self.alpha)
        return s


def simulation(white, black):
    board = chess.Board()
    p = 0
    moves = 0
    while True and moves < K:
        if p == 0:
            move = whitePlayerMove(board, white.alpha)
        else:
            move = blackPlayerMove(board, black.alpha)
        # print(move)
        board.push(move)
        p = 1 - p
        moves += 1
        if board.outcome() is not None:
            break

    # print(board)
    # print()
    # print()
    # res = 0
    if board.outcome() is None:
        # stockfish
        info = engine.analyse(board, chess.engine.Limit(depth=20))['score'].white()
        # print()
        # print('a')
        # print('Info: ', info)
        # print('Mat: ', info.mate())
        # print('Score:', info.score())
        info = info.mate() or info.score()
        # print('Res: ', info)
        if info == 0:
            res = 0
        if info > 0:
            res = 1
        if info < 0:
            res = -1
    else:
        if board.outcome().winner is None:
            res = 0
        else:
            if board.outcome().winner:
                res = 1
            else:
                res = -1

    white.result(black, res)
    black.result(white, -res)


players = [Player(i, 0.01 * i) for i in range(100)]
i = 0
for a in players:
    for b in players:
        if a != b:
            simulation(a, b)
            i += 1
    print(i)

players.sort()

engine.close()

for i in players:
    print(i)
    print()
