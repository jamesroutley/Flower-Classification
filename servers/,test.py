
import SocketServer
import time
from ConnectionHandler import ConnectionHandler
import os
import json

ranking = [1,2,3]

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


print json_list
#print json.dumps(json_list, separators=(',',':'))
