name_lookup = []
for i in range(1, 103):
    name_lookup.append('name' + str(i))

url_dummy = ["http://jamesroutley.co.uk/Flower-Classification/img/oxfordflower17/jpg/image_0001.jpg",    "http://jamesroutley.co.uk/Flower-Classification/img/oxfordflower17/jpg/image_1061.jpg", "http://jamesroutley.co.uk/Flower-Classification/img/oxfordflower17/jpg/image_0914.jpg", "http://jamesroutley.co.uk/Flower-Classification/img/oxfordflower17/jpg/image_0356.jpg", "http://jamesroutley.co.uk/Flower-Classification/img/oxfordflower17/jpg/image_1283.jpg", "http://jamesroutley.co.uk/Flower-Classification/img/oxfordflower17/jpg/image_1061.jpg", "http://jamesroutley.co.uk/Flower-Classification/img/oxfordflower17/jpg/image_0914.jpg", "http://jamesroutley.co.uk/Flower-Classification/img/oxfordflower17/jpg/image_0356.jpg"]

print url_dummy[1]

json_list = []
for i in range(1, 9):
    print i
    json_list.append({'title': name_lookup[i-1], 'image': url_dummy[i-1]})

print name_lookup[1]

print json_list
