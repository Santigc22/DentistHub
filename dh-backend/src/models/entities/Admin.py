class Admin(): 
    
    def __init__(self, id_admin, name=None, username=None, cc=None, password=None) -> None:
        self.id_admin = id_admin
        self.name = name
        self.username = username
        self.cc = cc
        self.password = password
        
    
    def to_JSON(self):
        return {
            'id_admin': self.id_admin,
            'name': self.name,
            'username': self.username,
            'cc': self.cc,
            'password': self.password
        }
        