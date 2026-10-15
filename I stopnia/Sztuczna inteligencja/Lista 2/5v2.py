from queue import PriorityQueue


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
        for point in self.points:
            if distance.get(point, 20000) > max:
                max = distance.get(point, 20000)
        self.H = max

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


class DijkstraNode:

    point = None
    G = 0

    def __init__(self, point):
        self.point = point

    def __lt__(self, other):
        return self.G <= other.G

    def __eq__(self, other):
        return self.point == other.point

    def __hash__(self):
        return hash(self.point)

    def genMove(self):
        ans = []
        for (i, j) in [(1, 0), (-1, 0), (0, 1), (0, -1)]:
            (x, y) = self.point
            if (x + i, y + j) not in walls:
                (x, y) = (x + i, y + j)

            node = DijkstraNode((x, y))
            node.G = self.G + 1

            ans.append(node)
        return ans


def Dijkstra(start: DijkstraNode):
    visited = set()
    priorityQue = PriorityQueue()
    priorityQue.put(start)
    visited.add(start)
    distance[start.point] = 0

    while not priorityQue.empty():
        current: DijkstraNode = priorityQue.get()
        if current.G < distance.get(current.point, 2000000):
            distance[current.point] = current.G
        for node in current.genMove():
            if node not in visited:
                visited.add(node)
                priorityQue.put(node)


def Astar(start: Node):
    visited = dict()
    start.calculateH()
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
            node.calculateH()
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
distance = dict()

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

for point in endPoint:
    Dijkstra(DijkstraNode(point))

print("Djikstra end")
start = Node(startPoints)
start.H = start.calculateH()
ans = Astar(start)
s = ''
for i in ans:
    s += i.prevMove

print(s)
output.write(s)
