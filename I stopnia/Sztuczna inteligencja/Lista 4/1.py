import random

import numpy as np

import reversi_engine as reversi


# white - minimum
# black - maximum
def heuristic(board):
    w, p = piece(board)
    if board.terminal():
        if board.result() < 0:
            return np.Inf
        if board.result() > 0:
            return -np.inf
        return 0
    return 80 * corners(board) + \
           10 * w + \
           10 * p + \
           10 * mobility(board)


def piece(board):
    weights = [
        [20, -3, 11, 8, 8, 11, -3, 20],
        [-3, -7, -4, 1, 1, -4, -7, -3],
        [11, -4, 2, 2, 2, 2, -4, 11],
        [8, 1, 2, -3, -3, 2, 1, 8],
        [8, 1, 2, -3, -3, 2, 1, 8],
        [11, -4, 2, 2, 2, 2, -4, 11],
        [-3, -7, -4, 1, 1, -4, -7, -3],
        [20, -3, 11, 8, 8, 11, -3, 20]
    ]

    val = 0
    white = 0
    black = 0
    for i in range(8):
        for j in range(8):
            if board.board[i][j]:
                white += 1
                val -= weights[i][j]
            else:
                black += 1
                val += weights[i][j]

    return val, black - white


def mobility(board):
    white = len(board.moves(1))
    black = len(board.moves(0))

    return black - white


def corners(board):
    white = 0
    black = 0
    corners = [board.get(0, 0), board.get(0, 8), board.get(8, 0), board.get(8, 8)]
    for i in corners:
        if i:
            white += 1
        else:
            black += 1

    return black - white


def maxValue(board, player, depth, alpha, beta):
    if depth == 0 or board.terminal():
        return heuristic(game)
    val = -np.inf
    for move in board.moves(player):
        board.do_move(move, player)
        val = max(val, minValue(board, 1 - player, depth - 1, alpha, beta))
        board.undo()
        if val >= beta:
            return val
        alpha = max(alpha, val)
    return val


def minValue(board, player, depth, alpha, beta):
    if depth == 0 or board.terminal():
        return heuristic(game)
    val = np.inf
    for move in board.moves(player):
        board.do_move(move, player)
        val = min(val, maxValue(board, 1 - player, depth - 1, alpha, beta))
        board.undo()
        if val <= alpha:
            return val
        beta = min(alpha, val)
    return val


# white - minimum
# black - maximum

def alphabetaPlayer(board, player):
    bestMove = None
    bestVal = np.inf
    for move in board.moves(player):
        board.do_move(move, player)
        v = maxValue(board, 1 - player, 0, -np.inf, np.inf)
        board.undo()
        if v < bestVal:
            bestVal = v
            bestMove = move
    return bestMove


bWin = 0


# 1 - white - #
# 0 - black - o

def randomPlayer(board, player):
    moves = board.moves(player)
    if moves:
        return random.choice(moves)
    return None


for i in range(0, 1000):
    p = 0
    game = reversi.Reversi()

    while True:
        if p == 0:
            move = randomPlayer(game, p)
        else:
            move = alphabetaPlayer(game, p)

        game.do_move(move, p)
        # print(move)
        # print(p)
        # game.draw()
        p = 1 - p
        if game.terminal():
            break
    if game.result() > 0:
        bWin += 1
    print(i)
    # print()
    # print()
    # game.draw()
    print('Wygrana' if game.result() > 0 else 'Pregrana')

print('*******')
print('Wygrane: ', bWin)
print('Porażki: ', 1000 - bWin)
