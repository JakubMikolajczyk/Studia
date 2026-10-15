import numpy as np
import pandas as pd
from matplotlib import pyplot as plt


cols = ["X", "Real", "Img"]
data = pd.read_csv("result.csv", sep=';', names=cols)


print(data)

fig, ax1 = plt.subplots()
ax2 = ax1.twinx()
ax1.plot(data.X, data.Real, 'g-')
ax2.plot(data.X, data.Img, 'b-')


ax1.set_xlabel('X')
ax1.set_ylabel('Real', color='g')
ax2.set_ylabel('Img', color='b')


plt.savefig("./venv/plot.png")
