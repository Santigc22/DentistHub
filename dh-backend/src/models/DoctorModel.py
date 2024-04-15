from database.db import get_connection
from .entities.Doctor import Doctor
import bcrypt # type: ignore


class DoctorModel():

    @classmethod
    def get_doctors(self, name=None, username=None, cc=None, page=None, page_size=None):
        try:
            connection = get_connection()
            doctors = []

            with connection.cursor() as cursor:
                query = "SELECT id_doctor, name, username, cc, password FROM doctor WHERE 1=1"
                conditions = []

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

                params = tuple(param for param in (
                    name, username, cc) if param is not None)

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
                    doctor = Doctor(row[0], row[1], row[2], row[3], row[4])
                    doctors.append(doctor.to_JSON())

                connection.close()
                return doctors
        except Exception as ex:
            raise Exception(ex)

    @classmethod
    def get_doctor(self, id_doctor):
        try:
            connection = get_connection()

            with connection.cursor() as cursor:
                cursor.execute(
                    "SELECT id_doctor,name,username,cc,password FROM doctor WHERE id_doctor = %s", (id_doctor,))
                row = cursor.fetchone()

                doctor = None
                if row != None:
                    doctor = Doctor(row[0], row[1], row[2], row[3], row[4])
                    doctor = doctor.to_JSON()

                    connection.close()
                    return doctor
        except Exception as ex:
            raise Exception(ex)

    @classmethod
    def add_doctor(self, doctor):
        try:
            if not doctor.name.strip():
                raise ValueError("Name cannot be empty")
            if not doctor.username.strip():
                raise ValueError("Username cannot be empty")
            if not doctor.password.strip():
                raise ValueError("Password cannot be empty")
            if not doctor.cc:
                raise ValueError("CC cannot be empty")
            
            if not isinstance(doctor.name, str):
                raise ValueError("Name must be string type")
            if not isinstance(doctor.username, str):
                raise ValueError("Username must be string type")
            if not isinstance(doctor.password, str):
                raise ValueError("Password must be string type")
            
            name = doctor.name.strip()
            username = doctor.username.strip()
            password = doctor.password.strip()
            cc = doctor.cc
            
            if cc < 0:
                raise ValueError("CC must be non-negative value")
            
            connection = get_connection()
            
            if len(name) > 50:
                raise ValueError("Name must be 50 characters or less")
            if len(username) > 30:
                raise ValueError("Username must be 30 characters or less")
            if len(password) > 20:
                raise ValueError("Password must be 20 characters or less")
            
            hashed_password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())

            with connection.cursor() as cursor:
                cursor.execute(
                    "SELECT username FROM doctor WHERE username = %s", (username,))
                existing_username = cursor.fetchone()

                if existing_username:
                    raise ValueError("Username already exists")

            with connection.cursor() as cursor:
                cursor.execute(
                    "INSERT INTO doctor (id_doctor, name, username, cc, password) VALUES (%s, %s, %s, %s, %s)",
                    (doctor.id_doctor, name, username, cc, hashed_password.decode('utf-8')))
                affected_rows = cursor.rowcount
                connection.commit()

                connection.close()
                return affected_rows
        except Exception as ex:
            raise Exception(ex)

    @classmethod
    def delete_doctor(self, doctor):
        try:
            connection = get_connection()

            with connection.cursor() as cursor:
                cursor.execute(
                    "DELETE FROM doctor WHERE id_doctor = %s", (doctor.id_doctor,))
                affected_rows = cursor.rowcount
                connection.commit()

                connection.close()
                return affected_rows
        except Exception as ex:
            raise Exception(ex)

    @classmethod
    def update_doctor(self, doctor):
        try:
            if not doctor.name.strip():
                raise ValueError("Name cannot be empty")
            if not doctor.username.strip():
                raise ValueError("Username cannot be empty")
            if not doctor.password.strip():
                raise ValueError("Password cannot be empty")
            if not doctor.cc:
                raise ValueError("CC cannot be empty")
            
            if not isinstance(doctor.name, str):
                raise ValueError("Name must be string type")
            if not isinstance(doctor.username, str):
                raise ValueError("Username must be string type")
            if not isinstance(doctor.password, str):
                raise ValueError("Password must be string type")
            
            name = doctor.name.strip()
            username = doctor.username.strip()
            password = doctor.password.strip()
            cc = doctor.cc
            
            if cc < 0:
                raise ValueError("CC must be non-negative value")
            
            if len(name) > 50:
                raise ValueError("Name exceeds the maximum length of 50 characters")
            if len(username) > 30:
                raise ValueError("Username exceeds the maximum length of 30 characters")
            if len(password) > 20:
                raise ValueError("Password exceeds the maximum length of 20 characters")
            
            hashed_password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())
            
            connection = get_connection()
            
            with connection.cursor() as cursor:
                cursor.execute("SELECT id_doctor FROM doctor WHERE username = %s AND id_doctor != %s",
                               (username, doctor.id_doctor))
                existing_doctor = cursor.fetchone()

            if existing_doctor:
                raise ValueError("Username already exists for doctors")


            with connection.cursor() as cursor:
                cursor.execute(
                    "UPDATE doctor SET name = %s, username = %s, cc = %s, password = %s WHERE id_doctor = %s",
                    (name, username, cc, hashed_password.decode('utf-8'), doctor.id_doctor))
                affected_rows = cursor.rowcount
                connection.commit()

                connection.close()
                return affected_rows
        except Exception as ex:
            raise Exception(ex)
