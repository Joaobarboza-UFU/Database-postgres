# Code beeing developed that reads a csv file containing all zip codes and creates a database containing these data
import psycopg2
import csv
import codecs
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT

f = open("utfcepos.txt" , "r" , encoding='utf-8')
contents = f.read()
newcontents = contents.replace('\t',',').replace('"',"'").replace("'","''")
f.close()

file = open("output.csv",'w',newline='', encoding='utf-8')
file.write(newcontents)
file.close

reader = csv.reader(open("output.csv", encoding="utf-8"))

conn = psycopg2.connect(host="localhost",
                        port=5432,
                        user="postgres",
                        password="postgres",
                        database="postgres"
                        )

conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
cursor = conn.cursor()

try:
    cursor.execute("CREATE database correios")

except Exception as erro:
    print(erro)

conn.commit()
cursor.close()
conn.close()
del(cursor)
del(conn)

conn = psycopg2.connect(host="localhost",
                        port=5432,
                        user="postgres",
                        password="postgres",
                        database="correios"
                        )

cursor = conn.cursor()

try:
    cursor.execute("CREATE SCHEMA if not exists bd")
    conn.commit()
except:
    print("Schema Already exists")


try:
    cursor.execute("CREATE TABLE bd.CEP (id serial PRIMARY KEY, CEP integer , UF varchar(4) not null , Cidade varchar(100) not null, Bairro varchar(100) not null , Rua varchar(100) not null , constraint unique_cep unique(cep));")
    conn.commit()
except:
    print("Table Already exists")

try:
    for row in reader:
        cursor.execute("""INSERT INTO bd.CEP(CEP, UF , Cidade , Bairro , Rua ) VALUES ({0},{1},{2},{3},{4})""" .format( row[0] , ("'{" + str(row[1]) + "}'"), ("'{" + str(row[2]) + "}'") , ("'{" + str(row[3]) + "}'") , ("'{" + str(row[4]) + "}'")) , row)
except Exception as erro:
    print(erro)

try:
    cursor.execute("CREATE or REPLACE VIEW bd.sp as SELECT Rua from bd.cep where Rua ilike '{Rua%}' and UF='{SP}'")
except Exception as erro:
    print(erro)

try:
    cursor.execute("CREATE or REPLACE VIEW bd.cidades_mg as SELECT DISTINCT Cidade from bd.cep where UF='{MG}'")
except Exception as erro:
    print(erro)

try:
    cursor.execute("CREATE or REPLACE VIEW bd.cidades_S_SP as select count(*) , Cidade from bd.cep where Cidade ilike '{S%}' and UF='{SP}' group by Cidade ")
except Exception as erro:
    print(erro)


conn.commit()
cursor.close()
conn.close()
