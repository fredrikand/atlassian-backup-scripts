#!/usr/bin/env python2.7

import json
from base64 import b64encode

import requests

USERNAME = ""
PASSWORD = ""
BITBUCKET_URL = "https://URL"

lockUrl = "%s/mvc/maintenance/lock" % BITBUCKET_URL
userAndPass = b64encode(b"%s:%s" % (USERNAME, PASSWORD)).decode("ascii")
headers = {'Content-type': 'application/json', 'Authorization': 'Basic %s' % userAndPass}

response = requests.post(lockUrl, headers=headers)
unlock_token = json.loads(response.content)['unlockToken']

print("Bitbucket has been locked for maintenance.  It can be unlocked with:")
print("    curl -u ... -X DELETE -H 'Content-type:application/json' '%s?token=%s'" % (lockUrl, unlock_token))

####
#### Do super-quick snapshots
####

unlock_payload = {"token": unlock_token}
response = requests.delete(lockUrl, headers=headers, params=unlock_payload)

print("Bitbucket has been unLocked")
