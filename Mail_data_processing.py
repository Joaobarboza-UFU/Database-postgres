# Code beeing developed that reads a csv file containing all zip codes and creates a database containing these data
my_file = open("book1.txt", "r" , encoding="utf8")
yourResult = [line.split(';') for line in my_file.readlines()]
