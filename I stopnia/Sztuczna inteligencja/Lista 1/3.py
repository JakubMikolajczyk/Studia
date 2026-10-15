import itertools

color = ['S', 'H', 'C', 'D']
Figurant = [1, 11, 12, 13]
Blotkarz = [2, 3, 4]

FigurantHand = list(itertools.combinations(itertools.product(Figurant, color), 5))
BlotkarzHand = list(itertools.combinations(itertools.product(Blotkarz, color), 5))


def isColor(hand):
    for i in range(1, 5):
        if hand[i][1] != hand[i - 1][1]:
            return False
    return True


def isStrit(hand):
    for i in range(1, 5):
        if (hand[i][0] - 1) != hand[i - 1][0]:
            return False
    return True


def group(hand):
    g = dict()
    for (a, b) in hand:
        if a in g:
            g[a] += 1
        else:
            g[a] = 1
    return g


def handToVariant(hand):
    if isStrit(hand) and isColor(hand):
        return 0

    g = group(hand)
    val = list(g.values())

    if len(g) == 2:
        if 4 in val:
            return 1
        if (val[0] == 3 and val[1] == 2) or (val[0] == 2 and val[1] == 3):
            return 2

    if isColor(hand):
        return 3
    if isStrit(hand):
        return 4
    if len(g) == 3:
        if 3 in val:
            return 5
        if val[0] == val[1] == 2 or val[0] == val[2] == 2 or val[1] == val[2] == 2:
            return 6
    if len(g) == 4:
        if 2 in val:
            return 7
    return 8


def numberOfVariants(hands):
    res = [0] * 9
    for i in hands:
        res[handToVariant(i)] += 1
    return res


def probability():
    figurant = numberOfVariants(FigurantHand)
    blotkarz = numberOfVariants(BlotkarzHand)
    num = 0
    den = sum(figurant) * sum(blotkarz)
    suma = sum(figurant)
    for i in range(0, 9):
        suma -= figurant[i]
        num += blotkarz[i] * suma

    return num/ den


print(probability())
