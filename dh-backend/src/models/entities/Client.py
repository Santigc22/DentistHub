class Client(): 
    
    def __init__(self, id_client, name=None, cc=None, age=None, address=None, phone=None) -> None:
        self.id_client = id_client
        self.name = name
        self.cc = cc
        self.age = age
        self.address = address
        self.phone = phone
        
    
    def to_JSON(self):
        return {
            'id_client': self.id_client,
            'name': self.name,
            'cc': self.cc,
            'age': self.age,
            'address': self.address,
            'phone': self.phone
        }
      