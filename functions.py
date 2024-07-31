import math

def sum(x, y):
    return x + y

def is_prime(num):
    for i in range(2, int(math.sqrt(num))+1):
        if num % i==0:
            print(f"{num} is not a prime number")
            return
    print(f"{num} is a prime number")