import requests

page_id = 142854

payload = {'action':'query', 'prop':'extracts', 'format':'json', 'exintro':'', 'explaintext':'', 'continue':''}

payload['pageids'] = str(page_id)

q = requests.get('https://en.wikipedia.org/w/api.php', params = payload)

print q.json()['query']['pages'][str(page_id)]['extract']
