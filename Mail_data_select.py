import psycopg2

conn = psycopg2.connect(host="localhost",
                        port=5432,
                        user="postgres",
                        password="postgres",
                        database="correios"
                        )

cursor = conn.cursor()
postgreSQL_select_Query = "select * from bd.cep"
cursor.execute(postgreSQL_select_Query)
print("Selecting rows from mobile table using cursor.fetchall")
cep_records = cursor.fetchall()

print("Print each row and it's columns values")
for row in cep_records:
    print("CEP = ", row[0], )
    print("Estado = ", row[1])
    print("Cidade = ", row[2],)
    print("Bairro", row[3])
    print("Rua" , row[4])
    print("\n")


conn.commit()
cursor.close()
conn.close()
