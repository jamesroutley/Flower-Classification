import math

# Interface to send and receive data bytes.
# TODO(james): This is not the ideal way to send and receive streams, there are
# certainly existing libraries doing this.
class ConnectionHandler:
  def __init__(self, sock):
    self.sock = sock;

  def send(self, data):
    lengthData = len(data)
    self.sock.send("%012d" % lengthData)
    self.sock.send(data)

  def recv(self):
    BYTES_PER_TRANSFER = 2;
    data = self.sock.recv(12)
    wholeData = ""

    if(data==""):
      pass
    else:
      lengthData = float(data)
      t = int(math.ceil(lengthData/BYTES_PER_TRANSFER))
      c = 0;
      while(c<t):
        data = self.sock.recv(BYTES_PER_TRANSFER)
        wholeData += data
        c += 1
    return wholeData
