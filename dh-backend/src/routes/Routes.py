from flask import Blueprint, jsonify, request
from models.AdminModel import AdminModel
from models.entities.Admin import Admin
from models.DoctorModel import DoctorModel
from models.entities.Doctor import Doctor
from models.ProcedureModel import ProcedureModel
from models.entities.Procedure import Procedure
import uuid

main = Blueprint('admin_blueprint', __name__)

# Admin routes


@main.route('/admins')
def get_admins():
    try:
        name = request.args.get('name')
        username = request.args.get('username')
        cc = request.args.get('cc')
        page = request.args.get('page')
        page_size = request.args.get('page_size')

        page = int(page) if page else None
        page_size = int(page_size) if page_size else None
        cc = int(cc) if cc else None

        admins = AdminModel.get_admins(
            name=name, username=username, cc=cc, page=page, page_size=page_size)
        return jsonify(admins)
    except Exception as ex:
        return jsonify({'message': str(ex)}), 500


@main.route('/admins/<id_admin>')
def get_admin(id_admin):
    try:
        admin = AdminModel.get_admin(id_admin)
        if admin != None:
            return jsonify(admin)
        else:
            return jsonify({'message': "entity not found"}), 404
    except Exception as ex:
        return jsonify({'message': str(ex)}), 500


@main.route('/admins/addAdmin', methods=['POST'])
def add_admin():
    try:

        name = request.json['name']
        username = request.json['username']
        cc = int(request.json['cc'])
        password = request.json['password']

        id_admin = uuid.uuid4()
        admin = Admin(str(id_admin), name, username, cc, password)

        affected_rows = AdminModel.add_admin(admin)

        if affected_rows == 1:
            response_data = {
                "id_admin": str(admin.id_admin)
            }
            return jsonify(response_data)
        else:
            return jsonify({'message': "Erroneous insertion"}), 400

    except Exception as ex:
        return jsonify({'message': str(ex)}), 500


@main.route('/admins/deleteAdmin/<id_admin>', methods=['DELETE'])
def delete_admin(id_admin):
    try:
        admin = Admin(id_admin)

        affected_rows = AdminModel.delete_admin(admin)

        if affected_rows == 1:
            response_data = {
                "deleted_Admin": str(admin.id_admin)
            }
            return jsonify(response_data)
        else:
            return jsonify({'message': "No Admin to delete"}), 404

    except Exception as ex:
        return jsonify({'message': str(ex)}), 500


@main.route('/admins/updateAdmin/<id_admin>', methods=['PUT'])
def update_admin(id_admin):
    try:

        name = request.json['name']
        username = request.json['username']
        cc = int(request.json['cc'])
        password = request.json['password']

        admin = Admin(id_admin, name, username, cc, password)

        affected_rows = AdminModel.update_admin(admin)

        if affected_rows == 1:
            response_data = {
                "updated_Admin": str(admin.id_admin)
            }
            return jsonify(response_data)
        else:
            return jsonify({'message': "No Admin to update"}), 400

    except Exception as ex:
        return jsonify({'message': str(ex)}), 500


# Doctor routes:

@main.route('/doctors')
def get_doctors():
    try:
        name = request.args.get('name')
        username = request.args.get('username')
        cc = request.args.get('cc')
        page = request.args.get('page')
        page_size = request.args.get('page_size')

        page = int(page) if page else None
        page_size = int(page_size) if page_size else None
        cc = int(cc) if cc else None

        doctors = DoctorModel.get_doctors(
            name=name, username=username, cc=cc, page=page, page_size=page_size)
        return jsonify(doctors)
    except Exception as ex:
        return jsonify({'message': str(ex)}), 500


@main.route('/doctors/<id_doctor>')
def get_doctor(id_doctor):
    try:
        doctor = DoctorModel.get_doctor(id_doctor)
        if doctor != None:
            return jsonify(doctor)
        else:
            return jsonify({'message': "entity not found"}), 404
    except Exception as ex:
        return jsonify({'message': str(ex)}), 500


@main.route('/doctors/addDoctor', methods=['POST'])
def add_doctor():
    try:

        name = request.json['name']
        username = request.json['username']
        cc = int(request.json['cc'])
        password = request.json['password']

        id_doctor = uuid.uuid4()
        doctor = Doctor(str(id_doctor), name, username, cc, password)

        affected_rows = DoctorModel.add_doctor(doctor)

        if affected_rows == 1:
            response_data = {
                "id_doctor": str(doctor.id_doctor)
            }
            return jsonify(response_data)
        else:
            return jsonify({'message': "Erroneous insertion"}), 400

    except Exception as ex:
        return jsonify({'message': str(ex)}), 500


@main.route('/doctors/deleteDoctor/<id_doctor>', methods=['DELETE'])
def delete_doctor(id_doctor):
    try:
        doctor = Doctor(id_doctor)

        affected_rows = DoctorModel.delete_doctor(doctor)

        if affected_rows == 1:
            response_data = {
                "deleted_Doctor": str(doctor.id_doctor)
            }
            return jsonify(response_data)
        else:
            return jsonify({'message': "No Doctor to delete"}), 404

    except Exception as ex:
        return jsonify({'message': str(ex)}), 500


@main.route('/doctors/updateDoctor/<id_doctor>', methods=['PUT'])
def update_doctor(id_doctor):
    try:

        name = request.json['name']
        username = request.json['username']
        cc = int(request.json['cc'])
        password = request.json['password']

        doctor = Doctor(id_doctor, name, username, cc, password)

        affected_rows = DoctorModel.update_doctor(doctor)

        if affected_rows == 1:
            response_data = {
                "updated_Doctor": str(doctor.id_doctor)
            }
            return jsonify(response_data)
        else:
            return jsonify({'message': "No Doctor to update"}), 400

    except Exception as ex:
        return jsonify({'message': str(ex)}), 500

# Procedure routes


@main.route('/procedures')
def get_procedures():
    try:
        procedures = ProcedureModel.get_procedures()
        return jsonify(procedures)
    except Exception as ex:
        return jsonify({'message': str(ex)}), 500


@main.route('/procedures/<id_procedure>')
def get_procedure(id_procedure):
    try:
        procedure = ProcedureModel.get_procedure(id_procedure)
        if procedure != None:
            return jsonify(procedure)
        else:
            return jsonify({'message': "entity not found"}), 404
    except Exception as ex:
        return jsonify({'message': str(ex)}), 500


@main.route('/procedures/addProcedure', methods=['POST'])
def add_aprocedure():
    try:

        name = request.json['name']
        amount = int(request.json['amount'])
        description = request.json['description']

        id_procedure = uuid.uuid4()
        procedure = Procedure(str(id_procedure), name, amount, description)

        affected_rows = ProcedureModel.add_procedure(procedure)

        if affected_rows == 1:
            response_data = {
                "id_procedure": str(procedure.id_procedure)
            }
            return jsonify(response_data)
        else:
            return jsonify({'message': "Erroneous insertion"}), 400

    except Exception as ex:
        return jsonify({'message': str(ex)}), 500


@main.route('/procedures/deleteProcedure/<id_procedure>', methods=['DELETE'])
def delete_procedure(id_procedure):
    try:
        procedure = Procedure(id_procedure)

        affected_rows = ProcedureModel.delete_procedure(procedure)

        if affected_rows == 1:
            response_data = {
                "deleted_Procedure": str(procedure.id_procedure)
            }
            return jsonify(response_data)
        else:
            return jsonify({'message': "No Procedure to delete"}), 404

    except Exception as ex:
        return jsonify({'message': str(ex)}), 500


@main.route('/procedures/updateProcedure/<id_procedure>', methods=['PUT'])
def update_procedure(id_procedure):
    try:

        name = request.json['name']
        amount = int(request.json['amount'])
        description = request.json['description']

        procedure = Procedure(id_procedure, name, amount, description)

        affected_rows = ProcedureModel.update_procedure(procedure)

        if affected_rows == 1:
            response_data = {
                "updated_Procedure": str(procedure.id_procedure)
            }
            return jsonify(response_data)
        else:
            return jsonify({'message': "No Procedure to update"}), 400

    except Exception as ex:
        return jsonify({'message': str(ex)}), 500
