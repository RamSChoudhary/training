import http.client
import json
import adal
import requests

#login url to azure
authentication_endpoint = 'https://login.microsoftonline.com/'

# create an app-registraion in azure portal
# where you get this app-id and app-secret and 
# also need to add iam roles to app
context = adal.AuthenticationContext(authentication_endpoint + '<<tenant id>>')
token_response = context.acquire_token_with_client_credentials('https://management.azure.com/', '<<app-id>>', '<<app-seret>>')

# get the bearer token 
access_token = token_response.get('accessToken')

#pass the api version
params = {'api-version': '2014-04-01'}
url = 'https://management.azure.com/subscriptions/<<subscription-id>>/resources' #
headers = {'Authorization': 'Bearer ' + access_token, 'Content-Type': 'application/json'}

r = requests.get(url, headers=headers, params=params)

print(json.dumps(r.json(), indent=4, separators=(',', ': ')))
y = json.loads(json.dumps(r.json(), indent=4, separators=(',', ': ')))


while True:
    subs_id = input('Enter Meta-data of Resource (location, kind, tags): ')
    for items in y['value']:
            result = items.get(''+ subs_id +'')
            if result:
                print(result)
            else: 
                print("No Record Found")
            #print(json.dumps(items[''+ subs_id +'']))
    if subs_id == "exit":
        break
        
    

