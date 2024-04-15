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
            if not isinstance(procedure.name, str):
                raise ValueError("Name must be string type")
            if not isinstance(procedure.description, str):
                raise ValueError("Description must be string type")
            
            name = procedure.name.strip()
            description = procedure.description.strip()
            amount = procedure.amount
            
            if amount < 0:
                raise ValueError("Amount must be non-negative value")
            
            connection = get_connection()
            
            if len(name) > 50:
                raise ValueError("Procedure name must be 50 characters or less")
            if len(description) > 200:
                raise ValueError("Procedure description must be 200 characters or less")

            with connection.cursor() as cursor:
                cursor.execute("INSERT INTO procedure (id_procedure, name, amount, description) VALUES (%s, %s, %s, %s)",
                               (procedure.id_procedure, name, amount, description))
                affected_rows = cursor.rowcount
                connection.commit()

            connection.close()
            return affected_rows
        except Exception as ex:
            raise Exception(ex)

    @classmethod
    def update_procedure(self, procedure):
        try:
            if not isinstance(procedure.name, str):
                raise ValueError("Name must be string type")
            if not isinstance(procedure.description, str):
                raise ValueError("Description must be string type")
            
            name = procedure.name.strip()
            description = procedure.description.strip()
            amount = procedure.amount
            
            if amount < 0:
                raise ValueError("Amount must be non-negative value")
            
            if len(name) > 50:
                raise ValueError("Name exceeds the maximum length of 50 characters")
            if len(description) > 30:
                raise ValueError("Description exceeds the maximum length of 200 characters")
            
            connection = get_connection()

            with connection.cursor() as cursor:
                cursor.execute("UPDATE procedure SET name = %s, amount = %s, description = %s WHERE id_procedure = %s", 
                               (name, amount, description, procedure.id_procedure))
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
