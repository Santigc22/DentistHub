class Doctor(): 
    
    def __init__(self, id_doctor, name=None, username=None, cc=None, password=None) -> None:
        self.id_doctor = id_doctor
        self.name = name
        self.username = username
        self.cc = cc
        self.password = password
        
    
    def to_JSON(self):
        return {
            'id_doctor': self.id_doctor,
            'name': self.name,
            'username': self.username,
            'cc': self.cc,
            'password': self.password
        }
      