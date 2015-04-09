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
import json

# The handler is created for each of incoming http requests and handle() will be
# called each time.
class ServerRequestHandler(SocketServer.BaseRequestHandler):
    def handle(self):
        connectionHandler = ConnectionHandler(self.request)
        data = connectionHandler.recv()

        start = time.time()

        # Run classification script
        ranking = mlab.server_classification(data, self.server.weight_matrix, self.server.net)

        connectionHandler.send(str(gen_json(ranking)))

        t = time.time() - start

        print('Finished processing. Required %f seconds.' % t)

def gen_json(ranking):

    with open('class_names.dat','r') as f:
        rows=[L.strip().split(',') for L in f]  # list of lists

    name_lookup_arr= list(rows)
    common_name = []
    genus = []

    for line in name_lookup_arr:
        genus.append(line[0])
        common_name.append(line[2])


    url_lookup = []
    for i in range(1, 103):
        url_lookup.append(str(i) + '.jpg')


    json_list = []
    for i in ranking:
        json_list.append({"common_name": common_name[int(i[0] - 1)], "image": url_lookup[int(i[0] - 1)], "genus": genus[int(i[0] - 1)]})


    return json.dumps(json_list, separators=(',',':'))




# The server is created at the start and calls the handler above.
class Server(SocketServer.ThreadingMixIn, SocketServer.TCPServer):
    def __init__(self, address, RequestHandler):
        SocketServer.TCPServer.__init__(self, address, RequestHandler)

        #Load MatLab code and net

        self.weight_matrix = mlab.load_weight_matrix()
        print('weight_matirx ready')
        self.net = mlab.load_net()
        print('net ready')
        print('backend server ready:')

if __name__ == '__main__':
    host = 'localhost'
    port = 60000

    server = Server((host, port), ServerRequestHandler)
    server.serve_forever()
