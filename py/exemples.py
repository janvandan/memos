print ("***** Return a list containing the Fibonacci series up to n *****")

def fib2(n):
    """Return a list containing the Fibonacci series up to n."""
    result = []
    a, b = 0, 1
    while a < n:
        result.append(a)
        a, b = b, a+b
    return result

f100 = fib2(100)
f100

print("resultat = ", fib2(100))

print ("***** variables dans def avec **keywords *****")

def cheeseshop(kind, *arguments, **keywords):
    print("-- Do you have any", kind, "?")
    print("-- I'm sorry, we're all out of", kind)
    for arg in arguments:
        print(arg)
    print("-" * 40)
    for kw in keywords:
        print(kw, ":", keywords[kw])

cheeseshop("Limburger", "It's very runny, sir.",
           "It's really very, VERY runny, sir.",
           shopkeeper="Michael Palin",
           client="John Cleese",
           sketch="Cheese Shop Sketch")

print ("***** variables dans def avec *args *****")

def concat(*args, sep="/"):
    return sep.join(args)

print("concat = ", concat("earth", "mars", "venus"))

separator = ";"
args = "sdsdd", "hjhhjh"

print("args = ", args, "separator.join =", separator.join(args))
