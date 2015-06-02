import json

with open('flower_info_temp.json') as data_file:
    data = json.load(data_file)

# print data['2']
# data['2'].update({'image': str(2)+'.jpg'})
# print data['2']

for i in range(102):
    flower_num = i + 1
    data[str(flower_num)].update({'image': str(flower_num)+'.jpg'})

g = open('f.json', 'w')
json.dump(data, g, sort_keys=True, indent=4, separators=(',', ': '))
