import random
from queue import Queue


class Node:
    points = set()
    parent = None
    prevMove = ""
    length = 0

    def __init__(self, points):
        self.points = points
        self.length = len(points)

    def __lt__(self, other):
        return self.length <= other.length

    def __eq__(self, other):
        return self.points == other.points

    def __hash__(self):
        return hash(frozenset(self.points))

    def getSet(self):
        return frozenset(self.points)

    def isEnd(self):
        for point in self.points:
            if point not in endPoint:
                return False
        return True

    def __len__(self):
        return self.length

    def genMove(self):
        ans = []
        for (i, j) in [(1, 0), (-1, 0), (0, 1), (0, -1)]:
            pointSet = set()
            for (x, y) in self.points:
                if (x + i, y + j) in walls:
                    pointSet.add((x, y))
                else:
                    pointSet.add((x + i, y + j))

            node = Node(pointSet)
            node.parent = self
            if (i, j) == (1, 0):
                node.prevMove = 'D'
            if (i, j) == (-1, 0):
                node.prevMove = 'U'
            if (i, j) == (0, 1):
                node.prevMove = 'R'
            if (i, j) == (0, -1):
                node.prevMove = 'L'

            ans.append(node)

        return ans


def reduceStartPoints(startNode):
    i = 100
    while i > 0:
        i -= 1
        min = 200000000
        for node in startNode.genMove():
            if len(node) < min:
                min = len(node)
                startNode = node
    return startNode


def reduceStartPointsv2(startNode):
    i = 110
    notChange = 0
    while i > 0:
        i -= 1
        min = 200000000
        if notChange > 5:
            test = random.randint(0, 3)
            startNode = startNode.genMove()[test]
        else:
            if (startNode.parent is not None) and (len(startNode) == len(startNode.parent)):
                notChange += 1
            else:
                notChange = 0
            for node in startNode.genMove():
                if len(node) < min:
                    min = len(node)
                    startNode = node

    return startNode


def reduceStartPointsv3(startNode):
    i = 110
    startSet = set()
    newSet = set()
    notChange = 0
    ans = None
    while i > 0:
        i -= 1
        min = 200000000
        if notChange > 5:
            if len(startSet) == 0:
                startSet.add(ans)
            for node in startSet:
                for move in node.genMove():
                    if len(move) <= 2:
                        return move
                    if len(move) < min:
                        ans = move
                        min = len(move)
                    newSet.add(move)
            startSet.update(newSet)
            newSet.clear()
        else:
            if (startNode.parent is not None) and (len(startNode) == len(startNode.parent)):
                notChange += 1
            else:
                notChange = 0
            for node in startNode.genMove():
                if len(node) < min:
                    min = len(node)
                    startNode = node
                    ans = node

    return ans


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
            visited.add(node)
            que.put(node)


def getPath(node):
    path = []
    while node.parent:
        path.append(node)
        node = node.parent
    return path[::-1]


input = open('zad_input.txt', 'r')
output = open('zad_output.txt', 'w')

startPoints = set()
endPoint = set()
walls = set()

for (i, line) in enumerate(input.read().splitlines()):
    for (j, c) in enumerate(line):
        if c == 'S':
            startPoints.add((i, j))
        if c == 'G':
            endPoint.add((i, j))
        if c == 'B':
            endPoint.add((i, j))
            startPoints.add((i, j))
        if c == '#':
            walls.add((i, j))

start = Node(startPoints)
temp = reduceStartPointsv3(start)
print(len(temp))
ans = getPath(temp)

ans = BFS(temp)
s = ''

for i in ans:
    s += i.prevMove

print(s)
output.write(s)
