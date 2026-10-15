import os
import sys


def outputToset(output: str):
    answer = set()
    for line in output.splitlines():
        ints = line.split(' ')
        answer.add(((int(ints[0]), int(ints[1])), (int(ints[2]), int(ints[3]))))
    return answer


def validate(cpp, input, output):
    cppOutput = os.popen("{} < {}".format(cpp, input)).read()
    cppOutput = outputToset(cppOutput.replace("\n", '')).pop()
    answers = outputToset(output)

    if cppOutput in answers:
        return True
    if (cppOutput[1], cppOutput[0]) in answers:
        return True
    return False

mode = sys.argv[1]
cmd = sys.argv[2]

