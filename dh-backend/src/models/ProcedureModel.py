from database.db import get_connection
from .entities.Procedure import Procedure


class ProcedureModel():

    @classmethod
    def get_procedures(self):
        try:
            connection = get_connection()
            procedures = []

            with connection.cursor() as cursor:
                cursor.execute(
                    "SELECT id_procedure, name, amount, description FROM procedure ORDER BY name ASC")
                resultset = cursor.fetchall()

                for row in resultset:
                    procedure = Procedure(row[0], row[1], row[2], row[3])
                    procedures.append(procedure.to_JSON())

            connection.close()
            return procedures
        except Exception as ex:
            raise Exception(ex)

    @classmethod
    def get_procedure(self, id_procedure):
        try:
            connection = get_connection()

            with connection.cursor() as cursor:
                cursor.execute(
                    "SELECT id_procedure, name, amount, description FROM procedure WHERE id_procedure = %s", (id_procedure,))
                row = cursor.fetchone()

                procedure = None
                if row != None:
                    procedure = Procedure(row[0], row[1], row[2], row[3])
                    procedure = procedure.to_JSON()

            connection.close()
            return procedure
        except Exception as ex:
            raise Exception(ex)

    @classmethod
    def add_procedure(self, procedure):
        try:
            connection = get_connection()

            with connection.cursor() as cursor:
                cursor.execute("INSERT INTO procedure (id_procedure, name, amount, description) VALUES (%s, %s, %s, %s)",
                               (procedure.id_procedure, procedure.name, procedure.amount, procedure.description))
                affected_rows = cursor.rowcount
                connection.commit()

            connection.close()
            return affected_rows
        except Exception as ex:
            raise Exception(ex)

    @classmethod
    def update_procedure(self, procedure):
        try:
            connection = get_connection()

            with connection.cursor() as cursor:
                cursor.execute("UPDATE procedure SET name = %s, amount = %s, description = %s WHERE id_procedure = %s", 
                               (procedure.name, procedure.amount, procedure.description, procedure.id_procedure))
                affected_rows = cursor.rowcount
                connection.commit()

            connection.close()
            return affected_rows
        except Exception as ex:
            raise Exception(ex)

    @classmethod
    def delete_procedure(self, procedure):
        try:
            connection = get_connection()

            with connection.cursor() as cursor:
                cursor.execute("DELETE FROM procedure WHERE id_procedure = %s", (procedure.id_procedure,))
                affected_rows = cursor.rowcount
                connection.commit()

            connection.close()
            return affected_rows
        except Exception as ex:
            raise Exception(ex)
