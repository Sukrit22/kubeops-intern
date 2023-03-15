myInput = input()
isPalin = True
for i in range(round(len(myInput)/2)+1):
    if myInput[i] != myInput[(-1)-i]:
        print("well its not palindrome")
        isPalin = False
        break

if isPalin:
    print("this is palindrome")
