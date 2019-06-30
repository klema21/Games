# Games
# Simple module for future games

class Player(object):
    """Player"""
    def __init__(self, name, score = 0):
        self.name = name
        self.score = score
    def __str__(self):
        rep = self.name + ":\t" + str(self.score)
        return rep
        
def ask_yes_or_no(question):
        response = None
        while response not in ("y", "n"):
            response = input(question).lower()
        return response

def ask_number(question, low, high):
        response = None
        while response not in range(low, high):
            response = int(input(question))
        return response
if __name__ == "__main__":
    print("You started the module 'Games' directly and didn't import it.")
    input("\nPress Enter key to exit.")
