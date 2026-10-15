import sys

import reversi_engine
import MCTS


class Player:
    def __init__(self):
        self.my_player = None
        self.game = reversi_engine.Reversi()
        self.MCTSRoot = MCTS.MCTS(self.game.copy())
        self.reset()

    def reset(self):
        self.game = reversi_engine.Reversi()
        self.MCTS = self.MCTSRoot
        self.my_player = 1
        self.say('RDY')

    def say(self, what):
        sys.stdout.write(what)
        sys.stdout.write('\n')
        sys.stdout.flush()

    def hear(self):
        line = sys.stdin.readline().split()
        return line[0], line[1:]

    def loop(self):
        while True:
            # print(self.game.moves(1 - self.my_player))
            cmd, args = self.hear()
            if cmd == 'HEDID':
                unused_move_timeout, unused_game_timeout = args[:2]
                move = tuple((int(m) for m in args[2:]))
                # moves = self.game.moves(1 - self.my_player)
                # if moves:
                #     move = moves[0]
                # else:
                #     move = (-1, -1)
                if move == (-1, -1):
                    move = None
                self.MCTS = self.MCTS.updateMove(move)
                self.game.do_move(move, 1 - self.my_player)
            elif cmd == 'ONEMORE':
                self.reset()
                continue
            elif cmd == 'BYE':
                break
            else:
                assert cmd == 'UGO'
                self.my_player = 0

            moves = self.game.moves(self.my_player)

            if moves:
                move = self.MCTS.bestAction()
                self.MCTS = self.MCTS.updateMove(move)
                self.game.do_move(move, self.my_player)
                # assert move is not None
            else:
                self.game.do_move(None, self.my_player)
                move = (-1, -1)
            self.say('IDO %d %d' % move)


if __name__ == '__main__':
    player = Player()
    player.loop()
