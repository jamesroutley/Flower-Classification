# Run this after launching the server. Server should say (1 + 100) = 101.

import socket
from ConnectionHandler import ConnectionHandler

# Connect to the matlab backend.
blub = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
blub.connect(('localhost', 60000))

# Send query.
ch = ConnectionHandler(blub)
ch.send('1')
print 'Received %s' % ch.recv()




