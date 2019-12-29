import math

gamma = 0.99
num_samples = 2000
epsilon = math.sqrt((math.log(2)-math.log(1-gamma))/(2*num_samples))
print(epsilon)