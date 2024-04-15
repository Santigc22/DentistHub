from database.db import get_connection
from .entities.Admin import Admin


class AdminModel():

    @classmethod
    def get_admins(self, name=None, username=None, cc=None, page=None, page_size=None):
        try:
            connection = get_connection()
            admins = []

            with connection.cursor() as cursor:
                query = "SELECT id_admin, name, username, cc, password FROM admin WHERE 1=1"
                conditions =[]
                
                if name:
                    conditions.append("name = %s")
                if username:
                    conditions.append("username = %s")
                if cc is not None:
                    conditions.append("cc = %s")
                    
                if conditions:
                    query += " AND " + " AND ".join(conditions)
                    
                query += " ORDER BY name ASC"
                
                print("Consulta SQL:", query)
                
                params = tuple(param for param  in (name, username, cc) if  param is not None)
                
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
                    admin = Admin(row[0], row[1], row[2], row[3], row[4])
                    admins.append(admin.to_JSON())

                connection.close()
                return admins
        except Exception as ex:
            raise Exception(ex)

    @classmethod
    def get_admin(self, id_admin):
        try:
            connection = get_connection()

            with connection.cursor() as cursor:
                cursor.execute(
                    "SELECT id_admin,name,username,cc,password FROM admin WHERE id_admin = %s", (id_admin,))
                row = cursor.fetchone()

                admin = None
                if row != None:
                    admin = Admin(row[0], row[1], row[2], row[3], row[4])
                    admin = admin.to_JSON()

                    connection.close()
                    return admin
        except Exception as ex:
            raise Exception(ex)

    @classmethod
    def add_admin(self, admin):
        try:
            if not isinstance(admin.name, str):
                raise ValueError("Name must be string type")
            if not isinstance(admin.username, str):
                raise ValueError("Username must be string type")
            if not isinstance(admin.password, str):
                raise ValueError("Password must be string type")
            
            name = admin.name.strip()
            username = admin.username.strip()
            password = admin.password.strip()
            cc = admin.cc
            
            if cc < 0:
                raise ValueError("CC must be non-negative value")
            
            
            connection = get_connection()
            
            if len(name) > 50:
                raise ValueError("Name must be 50 characters or less")
            if len(username) > 30:
                raise ValueError("Username must be 30 characters or less")
            if len(password) > 20:
                raise ValueError("Password must be 20 characters or less")
            
            with connection.cursor() as cursor:
                cursor.execute("SELECT username FROM admin WHERE username = %s", (username,))
                existing_username = cursor.fetchone()

                if existing_username:
                    raise ValueError("Username already exists")

            with connection.cursor() as cursor:
                cursor.execute(
                    "INSERT INTO admin (id_admin, name, username, cc, password) VALUES (%s, %s, %s, %s, %s)",
                    (admin.id_admin, name, username, cc, password))
                affected_rows = cursor.rowcount
                connection.commit()

                connection.close()
                return affected_rows
        except Exception as ex:
            raise Exception(ex)
        
    @classmethod
    def delete_admin(self, admin):
        try:
            connection = get_connection()

            with connection.cursor() as cursor:
                cursor.execute(
                    "DELETE FROM admin WHERE id_admin = %s", (admin.id_admin,))
                affected_rows = cursor.rowcount
                connection.commit()

                connection.close()
                return affected_rows
        except Exception as ex:
            raise Exception(ex)
        
    @classmethod
    def update_admin(self, admin):
        try:
            if not isinstance(admin.name, str):
                raise ValueError("Name must be string type")
            if not isinstance(admin.username, str):
                raise ValueError("Username must be string type")
            if not isinstance(admin.password, str):
                raise ValueError("Password must be string type")
            
            name = admin.name.strip()
            username = admin.username.strip()
            password = admin.password.strip()
            cc = admin.cc
            
            if cc < 0:
                raise ValueError("CC must be non-negative value")
            
            if len(name) > 50:
                raise ValueError("Name exceeds the maximum length of 50 characters")
            if len(username) > 30:
                raise ValueError("Username exceeds the maximum length of 30 characters")
            if len(password) > 20:
                raise ValueError("Password exceeds the maximum length of 20 characters")
            
            connection = get_connection()
            
            with connection.cursor() as cursor:
                cursor.execute("SELECT id_admin FROM admin WHERE username = %s AND id_admin != %s", 
                               (username, admin.id_admin))
                existing_admin = cursor.fetchone()

            if existing_admin:
                raise ValueError("Username already exists for admins")


            with connection.cursor() as cursor:
                cursor.execute(
                    "UPDATE admin SET name = %s, username = %s, cc = %s, password = %s WHERE id_admin = %s",
                    (name, username, cc, password, admin.id_admin))
                affected_rows = cursor.rowcount
                connection.commit()

                connection.close()
                return affected_rows
        except Exception as ex:
            raise Exception(ex)
