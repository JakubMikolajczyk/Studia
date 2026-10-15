from queue import Queue

walls = set()
boxGoal = set()


class Node:
    playerPosition = (0, 0)
    boxPositions = set()
    parent = None
    prevMove = ""

    def __eq__(self, other):
        return self.boxPositions == other.boxPositions and self.playerPosition == other.playerPosition

    def __hash__(self):
        temp = self.boxPositions.copy()
        (x, y) = self.playerPosition
        temp.add((x * -1, y * -1))
        return hash(frozenset(temp))

    def genMove(self):
        ans = []
        for (i, j) in [(1, 0), (-1, 0), (0, 1), (0, -1)]:
            new = Node()
            new.boxPositions = self.boxPositions.copy()
            new.playerPosition = self.playerPosition

            (x, y) = new.playerPosition
            if (x + i, y + j) in walls:  # Wall hit
                continue
            if (x + i, y + j) in new.boxPositions:  # box move??
                if (x + 2 * i, y + 2 * j) in walls:  # box hit wall, cannot move
                    continue
                if (x + 2 * i, y + 2 * j) in new.boxPositions:  # box hit another box, cannot move
                    continue

                new.boxPositions.remove((x + i, y + j))
                new.boxPositions.add((x + 2 * i, y + 2 * j))
                new.playerPosition = (x + i, y + j)
            else:  # player can move
                new.playerPosition = (x + i, y + j)

            new.parent = self
            if (i, j) == (1, 0):
                new.prevMove = 'D'
            if (i, j) == (-1, 0):
                new.prevMove = 'U'
            if (i, j) == (0, 1):
                new.prevMove = 'R'
            if (i, j) == (0, -1):
                new.prevMove = 'L'

            ans.append(new)

        return ans

    def isEnd(self):
        for box in self.boxPositions:
            if box not in boxGoal:
                return False
        return True

    def isDead(self):
        for (x, y) in self.boxPositions:
            if (x, y) not in boxGoal:
                if (x + 1, y) in walls:
                    if (x, y + 1) in walls or (x, y - 1) in walls:
                        return True
                if (x - 1, y) in walls:
                    if (x, y + 1) in walls or (x, y - 1) in walls:
                        return True
        return False


def BFS(start: Node):
    visited = set()
    que = Queue()
    que.put(start)
    visited.add(start)
    while not que.empty():
        current = que.get()
        for node in current.genMove():
            if node.isEnd():
                path = []
                path.append(node)
                while current.parent:
                    path.append(current)
                    current = current.parent
                return path[::-1]
            if node in visited:
                continue
            if node.isDead():
                continue
            visited.add(node)
            que.put(node)


input = open('zad_input.txt', 'r')
output = open('zad_output.txt', 'w')
start = Node()

for (i, line) in enumerate(input.read().splitlines()):
    for (j, c) in enumerate(line):
        if c == 'K':
            start.playerPosition = (i, j)
        if c == 'B':
            start.boxPositions.add((i, j))
        if c == 'G':
            boxGoal.add((i, j))
        if c == '*':
            start.boxPositions.add((i, j))
            boxGoal.add((i, j))
        if c == '+':
            start.playerPosition = (i, j)
            boxGoal.add((i, j))
        if c == 'W':
            walls.add((i, j))

ans = BFS(start)
s = ''
for i in ans:
    s += i.prevMove

print(s)
output.write(s)

# walls.add((3, 0))
# test = Node()
# test.playerPosition = (1, 0)
# test.boxPositions.add((2, 0))
# test.boxPositions.add((1, 1))
# abc = test.genMove()
#
# for i in abc:
#     print(i.prevMove)
#     print(i.playerPosition)
#     print(i.boxPositions)

#  DLURRRDLULLDDRULURUULDRDDRRULDLU
#  DLURRRDLULLDDRULURUULDRDDRRULDLU
