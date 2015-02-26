# Backend server that loads Matlab and models upon start and processes images
# via Matlab.
#
# The server can be brought up by simply running:
#
#    python backend_server.py
#
# Test this server via:
#
#    python test_backend_sever.py

import SocketServer
import time
from ConnectionHandler import ConnectionHandler
from mlabwrap import mlab
import os

# The handler is created for each of incoming http requests and handle() will be
# called each time.
class ServerRequestHandler(SocketServer.BaseRequestHandler):
  def handle(self):
    connectionHandler = ConnectionHandler(self.request)
    data = connectionHandler.recv()

    start = time.time()

    # TODO(James): Add your classification code here...

    # Use model via use_model.
    output = mlab.use_model(self.server.model, int(data))
    print('Output %d' % output)
    connectionHandler.send('%d' % output)

    t = time.time() - start

    print('Finished processing. Required %f seconds.' % t)

# The server is created at the start and calls the handler above.
class Server(SocketServer.ThreadingMixIn, SocketServer.TCPServer):
  def __init__(self, address, RequestHandler):
    SocketServer.TCPServer.__init__(self, address, RequestHandler)

    #TODO(James): Add your model loading code here...

    # Loads model from load_model.
    self.model = mlab.load_model()
    print('Model is ready:')
    print self.model

if __name__ == '__main__':
  host = 'localhost'
  port = 60000

  server = Server((host, port), ServerRequestHandler)
  server.serve_forever()


