class Procedure(): 
    
    def __init__(self, id_procedure, name=None, amount=None, description=None) -> None:
        self.id_procedure = id_procedure
        self.name = name
        self.amount = amount
        self.description = description
        
    
    def to_JSON(self):
        return {
            'id_procedure': self.id_procedure,
            'name': self.name,
            'amount': self.amount,
            'description': self.description
        }
      