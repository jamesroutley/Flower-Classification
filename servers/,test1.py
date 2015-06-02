import json

ranking = range(2, 6)
# print ranking

with open('f.json') as data_file:
    data = json.load(data_file)

json_list = []
for i in ranking:
    json_list.append(data[str(i)])

print json_list
