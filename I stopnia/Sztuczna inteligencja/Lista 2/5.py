from queue import PriorityQueue
board = []


def manhattan(p1, p2):
    temp = abs(p1[0] - p2[0]) + abs(p1[1] - p2[1])
    # temp += 1/55 * temp
    return temp


class Node:
    points = set()
    G = 0
    H = 0
    parent = None
    prevMove = ""

    def __init__(self, points):
        self.points = points

    def __lt__(self, other):
        return (self.G + self.H) <= (other.G + other.H)

    def __eq__(self, other):
        return self.points == other.points

    def __hash__(self):
        return hash(frozenset(self.points))

    def calculateH(self):
        max = -2
        for point1 in self.points:
            min = 200000
            for point2 in endPoint:
                val = manhattan(point1, point2)
                if val < min:
                    min = val
            if min > max:
                max = min
        return max

    def isEnd(self):
        for point in self.points:
            if point not in endPoint:
                return False
        return True

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
            node.G = self.G + 1
            node.H = node.calculateH()
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


def Astar(start):
    visited = set()
    priorityQue = PriorityQueue()
    priorityQue.put(start)
    visited.add(start)
    while not priorityQue.empty():
        current = priorityQue.get()
        visited.add(current)
        if current.H == 0:
            path = []
            while current.parent:
                path.append(current)
                current = current.parent
            return path[::-1]

        for node in current.genMove():
            if node in visited:
                continue
            priorityQue.put(node)


def Astarv2(start):
    visited = dict()
    visited[start] = start
    priorityQue = PriorityQueue()
    priorityQue.put(start)

    while not priorityQue.empty():
        current = priorityQue.get()
        if current.H == 0:
            path = []
            while current.parent:
                path.append(current)
                current = current.parent
            return path[::-1]

        for node in current.genMove():
            if node in visited:
                nodeVisited = visited.get(node)
                if node.G + node.H >= nodeVisited.G + nodeVisited.H or node.G + node.H >= 55:
                    continue
            visited[node] = node
            priorityQue.put(node)


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
start.H = start.calculateH()
ans = Astarv2(start)
s = ''
for i in ans:
    s += i.prevMove

print(s)
output.write(s)
