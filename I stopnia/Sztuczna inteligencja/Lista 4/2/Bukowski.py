#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import random
import sys
from jungle_engine import Jungle

N = 20000

class Simulator:
    def __init__(self):
        self.reset()

    def reset(self):
        self.game = Jungle()        

    def copy(self, jungle_game):
        self.game.board = [ [ jungle_game.board[j][i] for i in range(len(jungle_game.board[0]))] for j in range(len(jungle_game.board))]
        self.game.pieces[0] = jungle_game.pieces[0].copy()
        self.game.pieces[1] = jungle_game.pieces[1].copy()
        self.game.curplayer = jungle_game.curplayer
        self.game.peace_counter = jungle_game.peace_counter
        self.game.winner = jungle_game.winner
        
    def simulate(self, player, state, simulated_move, moves):
        self.reset()   
        self.copy(state)
        self.game.do_move(simulated_move)
        won = 0
        played = 0
        for _ in range(int(moves)):
            if self.game.victory(player):
                won += self.game.winner == player
                played += 1
                self.reset()
                self.copy(state)
                self.game.do_move(simulated_move)
            curmoves = self.game.moves(self.game.curplayer)
            move = random.choice(curmoves)
            self.game.do_move(move)
        return won / played            


class Player(object):
    def __init__(self):
        self.reset()

    def reset(self):
        self.game = Jungle()
        self.my_player = 1
        self.say('RDY')

    def say(self, what):
        sys.stdout.write(what)
        sys.stdout.write('\n')
        sys.stdout.flush()

    def hear(self):
        line = sys.stdin.readline().split()
        return line[0], line[1:]
    
    def pick_move(self, moves):
        simulator = Simulator()
        m_per_sim = N / len(moves)
        ratios = []
        for m in moves:
            ratio = simulator.simulate(self.my_player, self.game, m, m_per_sim)
            ratios.append(ratio)
        
        picked = moves[0]
        max = 0
        result = zip(moves, ratios)
        for r in result:
            if r[1] > max:
                max = r[1]
                picked = r[0]
        return picked

    def loop(self):
        while True:
            cmd, args = self.hear()
            if cmd == 'HEDID':
                unused_move_timeout, unused_game_timeout = args[:2]
                move = tuple((int(m) for m in args[2:]))
                if move == (-1, -1, -1, -1):
                    move = None
                else:
                    xs, ys, xd, yd = move
                    move = ( (xs, ys), (xd, yd))
                        
                self.game.do_move(move)
            elif cmd == 'ONEMORE':
                self.reset()
                continue
            elif cmd == 'BYE':
                break
            else:
                assert cmd == 'UGO'
                #assert not self.game.move_list
                self.my_player = 0

            moves = self.game.moves(self.my_player)
            if moves:
                move = self.pick_move(moves)
                self.game.do_move(move)
                move = (move[0][0], move[0][1], move[1][0], move[1][1])
            else:
                self.game.do_move(None)
                move = (-1, -1, -1, -1)
            self.say('IDO %d %d %d %d' % move)


if __name__ == '__main__':
    player = Player()
    player.loop()
