from ConnectionHandler import ConnectionHandler
import socket
from flask import Flask
app = Flask(__name__)

@app.route('/<num>')
def AddHundred(num):
  # Connect to the matlab backend.
  blub = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  blub.connect(('localhost', 60000))

  # Send query.
  ch = ConnectionHandler(blub)
  ch.send(num)

  # Display the result.
  return ch.recv()

if __name__ == "__main__":
    app.run(debug=True)



