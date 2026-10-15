import time

f_dic = open('words_for_ai1.txt', 'r')
dic = set(f_dic.read().splitlines())

def insert_space(str):
    leng = len(str) + 1
    list = [(-1, '', 0)] * leng
    list[0] = (0, '', 0)

    for i in range(1, leng):
        # list.append((-1, '', 0))
        word = ''
        mi = min(i, 29)
        for k in range(0, mi):
            word = str[i - k - 1] + word
            # word = str[i - k - 1: i]
            current = 0
            # print(word)
            if list[i - k - 1][0] != -1 and word in dic:
                l = k + 1  # len(word)
                current = l * l + list[i - k - 1][0]
                # print(current)
                if current > list[i][0]:
                    list[i] = (current, word, l)

    # print(list)
    ans = ''
    iter = len(list) - 1
    while iter > 0:
        ans = list[iter][1] + ' ' + ans
        iter -= list[iter][2]

    return ans[:-1]

# print(insert_space('ofiarowanymartwąpodniosłempowiek'))

# start_time = time.time()
# print(insert_space('powrótpaniczaspotkaniesiępierwszewpokoikudrugieustołuważnasędziegonaukaogrzecznościpodkomorzegouwagipolitycznenadmodamipocząteksporuokusegoisokołażalewojskiegoostatniwoźnytrybunałurzutokanaówczesnystanpolitycznylitwyieuropy'))
# print("--- %s seconds ---" % (time.time() - start_time))

input = open('zad2_input.txt', 'r')
output = open('zad2_output.txt', 'w')

for i in input.read().splitlines():
    start_time = time.time()
    output.write(insert_space(i) + '\n')
    print("--- %s seconds ---" % (time.time() - start_time))

input.close()
output.close()
