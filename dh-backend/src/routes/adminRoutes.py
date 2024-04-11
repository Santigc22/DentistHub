from flask import Blueprint, jsonify, request
from models.AdminModel import AdminModel
from models.entities.Admin import Admin
import uuid

main = Blueprint('admin_blueprint', __name__)


@main.route('/')
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
        
        admins = AdminModel.get_admins(name=name, username=username, cc=cc, page=page, page_size=page_size)
        return jsonify(admins)
    except Exception as ex:
        return jsonify({'message': str(ex)}), 500


@main.route('/<id_admin>')
def get_admin(id_admin):
    try:
        admin = AdminModel.get_admin(id_admin)
        if admin != None:
            return jsonify(admin)
        else:
            return jsonify({'message': "entity not found"}), 404
    except Exception as ex:
        return jsonify({'message': str(ex)}), 500


@main.route('/addAdmin', methods=['POST'])
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


@main.route('/deleteAdmin/<id_admin>', methods=['DELETE'])
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
    
@main.route('/updateAdmin/<id_admin>', methods=['PUT'])
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
            return jsonify({'message': "No movie to update"}), 400

    except Exception as ex:
        return jsonify({'message': str(ex)}), 500

