from database.db import get_connection
from .entities.Client import Client


class ClientModel():

    @classmethod
    def get_clients(self, name=None, cc=None, phone=None, page=None, page_size=None):
        try:
            connection = get_connection()
            clients = []

            with connection.cursor() as cursor:
                query = "SELECT id_client, name, cc, age, address, phone FROM client WHERE 1=1"
                conditions =[]
                
                if name:
                    conditions.append("name = %s")
                if cc is not None:
                    conditions.append("cc = %s")
                if phone is not None:
                    conditions.append("phone = %s")
                    
                if conditions:
                    query += " AND " + " AND ".join(conditions)
                    
                query += " ORDER BY name ASC"
                
                print("Consulta SQL:", query)
                
                params = tuple(param for param  in (name, cc, phone) if  param is not None)
                
                if page is not None and page_size is not None:
                    offset = (page - 1) * page_size
                    query += " LIMIT %s OFFSET %s"
                    print("Parámetros:", params + (page_size, offset))
                    cursor.execute(query, params + (page_size, offset))
                else:
                    print("Parámetros:", params)
                    cursor.execute(query, params)
                
                resultset = cursor.fetchall()

                for row in resultset:
                    client = Client(row[0], row[1], row[2], row[3], row[4], row[5])
                    clients.append(client.to_JSON())

                connection.close()
                return clients
        except Exception as ex:
            raise Exception(ex)

    @classmethod
    def get_client(self, id_client):
        try:
            connection = get_connection()

            with connection.cursor() as cursor:
                cursor.execute(
                    "SELECT id_client,name,cc,age,address,phone FROM client WHERE id_client = %s", (id_client,))
                row = cursor.fetchone()

                client = None
                if row != None:
                    client = Client(row[0], row[1], row[2], row[3], row[4], row[5])
                    client = client.to_JSON()

                    connection.close()
                    return client
        except Exception as ex:
            raise Exception(ex)

    @classmethod
    def add_client(self, client):
        try:
            connection = get_connection()
            
            with connection.cursor() as cursor:
                cursor.execute("SELECT cc FROM client WHERE cc = %s", (client.cc,))
                existing_username = cursor.fetchone()

                if existing_username:
                    raise ValueError("Client identification already exists")

            with connection.cursor() as cursor:
                cursor.execute(
                    "INSERT INTO client (id_client, name, cc, age, address, phone) VALUES (%s, %s, %s, %s, %s, %s)",
                    (client.id_client, client.name, client.cc, client.age, client.address, client.phone))
                affected_rows = cursor.rowcount
                connection.commit()

                connection.close()
                return affected_rows
        except Exception as ex:
            raise Exception(ex)
        
    @classmethod
    def delete_client(self, client):
        try:
            connection = get_connection()

            with connection.cursor() as cursor:
                cursor.execute(
                    "DELETE FROM client WHERE id_client = %s", (client.id_client,))
                affected_rows = cursor.rowcount
                connection.commit()

                connection.close()
                return affected_rows
        except Exception as ex:
            raise Exception(ex)
        
    @classmethod
    def update_client(self, client):
        try:
            connection = get_connection()

            with connection.cursor() as cursor:
                cursor.execute(
                    "UPDATE client SET name = %s, cc = %s, age = %s, address = %s, phone = %s WHERE id_client = %s",
                    (client.name, client.cc, client.age, client.address, client.phone, client.id_client))
                affected_rows = cursor.rowcount
                connection.commit()

                connection.close()
                return affected_rows
        except Exception as ex:
            raise Exception(ex)
