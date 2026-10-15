def B(i, j):
    return 'B_%d_%d' % (i, j)


def domains(Vs):
    return [q + ' in 0..1' for q in Vs]


def sum(Qs, val):
    return 'sum([' + ', '.join(Qs) + '], #=, ' + str(val) + ')'


def get_column(j):
    return [B(i, j) for i in range(C)]


def get_raw(i):
    return [B(i, j) for j in range(R)]


def radarVertical():
    return [sum(get_column(j), cols[j]) for j in range(C)]


def radarHorizontal():
    return [sum(get_raw(i), rows[i]) for i in range(C)]


def available3x1(Qs):
    return 'tuples_in( [[' + ', '.join(Qs) + ']], [ [0,0,0], [1,1,0], [1,0,0], [0,1,1], [0,0,1], [1,1,1], [1,0,1]] )'


def available2x2(Qs):
    return 'tuples_in( [[' + ', '.join(Qs) + ']], ' \
                                          '[[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1], [1, 1, 0, 0], ' \
                                          '[1, 0, 1, 0], [0, 1, 0, 1], [0, 0, 1, 1], [1, 1, 1, 1], [0, 0, 0, 0]] )'


def block3x1(i, j):
    return [B(i, y) for y in range(j, j + 3)]


def block2x2(i, j):
    return [B(x, y) for x in range(i, i + 2) for y in range(j, j + 2)]


def blocks():
    l = []
    for i in range(R - 1):
        for j in range(C - 1):
            l.append(available3x1(block3x1(i, j)))
            l.append(available3x1(block3x1(j, i)))
            l.append(available2x2(block2x2(i, j)))
    return l


def storms(rows, cols, triples):
    writeln(':- use_module(library(clpfd)).')

    bs = [B(i, j) for i in range(R) for j in range(C)]

    writeln('solve([' + ', '.join(bs) + ']) :- ')

    # TODO: add some constraints
    cs = domains(bs) + radarVertical() + radarHorizontal() + blocks()


    for i, j, val in triples:
        cs.append('%s #= %d' % (B(i, j), val))

    # writeln('    [%s] = [1,1,0,1,1,0,1,1,0,1,1,0,0,0,0,0,0,0,1,1,1,1,1,0,1,1,1,1,1,0,1,1,1,1,1,0],' % (
    #     ', '.join(bs),))  # only for test 1
    for c in cs:
        print(c)
        writeln(c + ',')
    writeln('    labeling([ff], [' + ', '.join(bs) + ']).')
    writeln('')
    writeln(":- tell('prolog_result.txt'), solve(X), write(X), nl, told.")


def writeln(s):
    output.write(s + '\n')


txt = open('zad_input.txt').readlines()
output = open('zad_output.txt', 'w')

rows = list(map(int, txt[0].split()))
cols = list(map(int, txt[1].split()))

R = len(rows)
C = len(cols)

triples = []

for i in range(2, len(txt)):
    if txt[i].strip():
        triples.append(map(int, txt[i].split()))

storms(rows, cols, triples)
