import json

#loading json files
f = open('D:\Python\PY1\sample.json')
obj = json.load(f)

#taking user input
inp = input('Enter data :')

# spliting user input
arr = inp.split('/')

# total characters in user input
total = len(arr)

#intializing variable for printing o/p
i = 1

for items in arr:
    data = obj.get(items)

    #if loop ends than print the result
    if i == total:
        print(data)

    if data == None:
        print('data not found')
        break
    else:
        #assigning data again into obj
        #therefore in next loop it will 
        #get the update data
        obj = data
        i += 1
        continue
       
    