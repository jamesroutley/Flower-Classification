a = [[ 77.], [ 10.], [  1.], [ 49.], [ 45.], [ 61.], [ 66.], [ 60.]]

list = []

name_lookup = []
for i in range(1, 103):
    name_lookup.append('name' + str(i))


url_lookup = []
for i in range(1, 103):
    url_lookup.append('url' + str(i))


for i in a:
    list.append({'title': name_lookup[int(i[0] - 1)], 'url': url_lookup[int(i[0] - 1)]})

print list
