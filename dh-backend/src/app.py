from flask import Flask
from configuration import config
from routes import adminRoutes
from flask_cors import CORS # type: ignore

app = Flask(__name__)

CORS(app, resources={"*": {"origins": "http://localhost:3000"}})

def page_not_found(error):
    return "<h1>Page not found</h1>", 404

if __name__ == '__main__':
    app.config.from_object(config['development'])
    
    app.register_blueprint(adminRoutes.main, url_prefix='/api/admins')
    
    app.register_error_handler(404, page_not_found)
    app.run()
