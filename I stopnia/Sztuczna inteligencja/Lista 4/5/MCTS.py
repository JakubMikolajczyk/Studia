import datetime
import random

import numpy as np

import reversi_engine


class MCTS:

    def __init__(self, root: reversi_engine.Reversi, player=0, parent=None, parentMove=None):
        self.state: reversi_engine.Reversi = root
        self.player = player
        self.parent = parent
        self.parentMove = parentMove
        self.children = []
        self.visitNum = 0
        self.result = dict()
        self.result[-1] = 0
        self.result[0] = 0
        self.result[1] = 0
        self.unvisited = root.moves(self.player)
        if len(self.unvisited) == 0:
            self.unvisited.append(None)

    def bestAction(self):
        startTime = datetime.datetime.now()

        while (datetime.datetime.now() - startTime).total_seconds() < 0.5:
            leaf = self.select()
            simResult = leaf.rollout()
            leaf.backPropagate(simResult)

        return self.bestChild().parentMove

    def rollout(self):
        currentRollout = self.state.copy()
        player = self.player
        while not currentRollout.terminal():
            moves = currentRollout.moves(player)
            if moves:
                move = random.choice(moves)
            else:
                move = None
            currentRollout.do_move(move, player)
            player = 1 - player

        result = currentRollout.result()
        if result == 0:
            return 0

        if result < 0 and self.player == 0:
            return -1
        if result > 0 and self.player == 1:
            return -1

        if result < 0 and self.player == 1:
            return 1
        if result > 0 and self.player == 0:
            return 1

    def bestChild(self, param=0.1):
        # self.state.draw()
        # print('childLen: ' , len(self.children))
        # print('unvisitedLen: ' , len(self.unvisited))
        # print('Is end: ', self.state.terminal())
        # print('ParentMove: ', self.parentMove)
        # print('Turn:', self.player)

        weights = [(child.result[1] - child.result[-1]) / child.visitNum + param * np.sqrt(
            2 * np.log(self.visitNum) / child.visitNum) for child in self.children]

        return self.children[np.argmax(weights)]

    def backPropagate(self, result):
        self.visitNum += 1
        self.result[result] += 1
        if self.parent:
            self.parent.backPropagate(result * -1)

    def select(self):
        node = self
        while node.fullExpanded():
            node = node.bestChild()

        if not node.fullExpanded():
            return node.pickUnvisited()

        return node

    def pickUnvisited(self):
        move = self.unvisited.pop()
        board = self.state.copy()
        board.do_move(move, self.player)
        newMCTS = MCTS(board, 1 - self.player, self, move)

        self.children.append(newMCTS)
        return newMCTS

    def fullExpanded(self):
        return len(self.unvisited) == 0

    def updateMove(self, move):

        if move in self.unvisited or move is None:
            board = self.state.copy()
            board.do_move(move, self.player)
            newMCTS = MCTS(board, 1 - self.player, self, move)
            if move is not None:
                self.unvisited.remove(move)
            self.children.append(newMCTS)
            return newMCTS

        for child in self.children:
            if child.parentMove == move:
                return child
