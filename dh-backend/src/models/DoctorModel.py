from database.db import get_connection
from .entities.Doctor import Doctor


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
            connection = get_connection()

            with connection.cursor() as cursor:
                cursor.execute(
                    "SELECT username FROM doctor WHERE username = %s", (doctor.username,))
                existing_username = cursor.fetchone()

                if existing_username:
                    raise ValueError("Username already exists")

            with connection.cursor() as cursor:
                cursor.execute(
                    "INSERT INTO doctor (id_doctor, name, username, cc, password) VALUES (%s, %s, %s, %s, %s)",
                    (doctor.id_doctor, doctor.name, doctor.username, doctor.cc, doctor.password))
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
            connection = get_connection()

            with connection.cursor() as cursor:
                cursor.execute(
                    "UPDATE doctor SET name = %s, username = %s, cc = %s, password = %s WHERE id_doctor = %s",
                    (doctor.name, doctor.username, doctor.cc, doctor.password, doctor.id_doctor))
                affected_rows = cursor.rowcount
                connection.commit()

                connection.close()
                return affected_rows
        except Exception as ex:
            raise Exception(ex)
