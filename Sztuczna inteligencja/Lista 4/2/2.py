import sys

import jungle

N = 20000


class Player:
    def __init__(self):
        self.my_player = None
        self.game = None
        self.reset()

    def reset(self):
        self.game = jungle.Jungle()
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
            # print("enemy", self.game.moves(1 - self.my_player))
            cmd, args = self.hear()
            if cmd == 'HEDID':
                unused_move_timeout, unused_game_timeout = args[:2]
                move = tuple((int(m) for m in args[2:]))
                if move == (-1, -1, -1, -1):
                    move = None
                else:
                    xs, ys, xd, yd = move
                    move = ((xs, ys), (xd, yd))

                self.game.do_move(move)
            elif cmd == 'ONEMORE':
                self.reset()
                continue
            elif cmd == 'BYE':
                break
            else:
                assert cmd == 'UGO'
                # assert not self.game.move_list
                self.my_player = 0

            moves = self.game.moves(self.my_player)
            if moves:
                move = self.simulateMove(moves)
                self.game.do_move(move)
                move = (move[0][0], move[0][1], move[1][0], move[1][1])
            else:
                self.game.do_move(None)
                move = (-1, -1, -1, -1)
            self.say('IDO %d %d %d %d' % move)

    def simulation(self, game: jungle.Jungle, n):
        win, lose = (0, 0)
        gameCopy = game.copy()
        while n > 0:
            if gameCopy.victory(gameCopy.curplayer):
                if gameCopy.winner == self.my_player:
                    win += 1
                else:
                    lose += 1
                gameCopy = game.copy()

            random = gameCopy.random_move(gameCopy.curplayer)
            # print("random", random)
            gameCopy.do_move(random)
            n -= 1

        # print("simulation end", win, lose)
        return win / lose if lose != 0 else 0

    def simulateMove(self, moves):
        bestMove = moves[0]
        best = -1
        # print("player", moves)
        for move in moves:
            # print("testing move:", move)
            gameCopy: jungle.Jungle = self.game.copy()
            gameCopy.do_move(move)
            simulation = self.simulation(gameCopy, N / len(moves))
            if simulation > best:
                best = simulation
                bestMove = move
        return bestMove


if __name__ == '__main__':
    player = Player()
    player.loop()
