import csv
import codecs

f = open("utfcepos.txt" , "r" , encoding='utf-8')
contents = f.read()
newcontents = contents.replace('\t',',').replace('"',"'").replace("'","''")
f.close()

file = open("output.csv",'w',newline='', encoding='utf-8')
file.write(newcontents)
file.close
