import requests
import csv
import json

# Set up Wikipedia api use
payload = {'action':'query', 'prop':'extracts', 'format':'json', 'exintro':'', 'explaintext':'', 'redirects':''}

# Load flower common names
with open('class_names.dat','r') as f:
    raw_data=[L.strip().split(',') for L in f]

# Dict to store flower info
d = {}

for i in range(102):
    flower_num = i + 1

    # Get flower info from Wikipedia
    payload['titles'] = raw_data[i][0] + " " + raw_data[i][1]
    q = requests.get('https://en.wikipedia.org/w/api.php', params = payload)
    # Temporary workaround
    page_nums = []
    for page_num in q.json()['query']['pages']:
        page_nums.append(page_num)

    if page_nums[0] != '-1':
        s = q.json()['query']['pages'][page_nums[0]]['extract']
    else:
        s = ""


    d.update({flower_num : {'genus': raw_data[i][0], 'species': raw_data[i][1], 'common_name' : raw_data[i][2], 'wiki_info' : s }})

# print d
g = open('flower_info_1.json', 'w')
json.dump(d, g, sort_keys=True, indent=4, separators=(',', ': '))
