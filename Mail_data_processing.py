# Code beeing developed that reads a csv file containing all zip codes and creates a database containing these data
reader = csv.reader(open("output.csv", encoding="utf-8"))

conn = psycopg2.connect(host="localhost",
                        port=5432,
                        user="postgres",
                        password="postgres",
                        database="correios"
                        )
cursor = conn.cursor()

cursor.execute("CREATE SCHEMA bd")
cursor.execute("CREATE TABLE bd.CEP (id serial PRIMARY KEY, CEP integer , UF varchar[4] not null , Cidade varchar[40] not null, Bairro varchar[50] not null , Rua varchar[50] not null);")

for row in reader:
    cursor.execute("""INSERT INTO bd.cep(CEP, UF , Cidade , Bairro , Rua ) VALUES ({0},{1},{2},{3},{4})""" .format( row[0] , ("'{" + str(row[1]) + "}'"), ("'{" + str(row[2]) + "}'") , ("'{" + str(row[3]) + "}'") , ("'{" + str(row[4]) + "}'")) , row)

conn.commit()
cursor.close()
conn.close()
