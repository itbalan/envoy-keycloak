package envoy.authz

import input.attributes.request.http as http_request

apikey = { "payload": payload } {
    api_key := http_request.headers.apikey
    payload := base64.decode(api_key)
}

default allow = {
	"allowed": false,
	"reason": "unauthorized resource access"
}

allow {
    action_allowed
}

action_allowed {
  http_request.method == "GET"
  http_request.headers.from == "partner1"
  apikey.payload == http_request.headers.from
  glob.match("/test*", [], http_request.path)
}

action_allowed {
  http_request.method == "GET"
  http_request.headers.from == "partner2"
  apikey.payload == http_request.headers.from
  glob.match("/test*", [], http_request.path)
}

action_allowed {
  http_request.method == "POST"
  http_request.headers.from == "partner2"
  glob.match("/test*", [], http_request.path)
}

#Allow all downstream systems to access POST method/endpoints of template service
action_allowed {
  http_request.method == "POST"
  glob.match("/template*", [], http_request.path)
}

#Allow all downstream systems to access GET method/endpoints of template service
action_allowed {
  http_request.method == "GET"
  glob.match("/template*", [], http_request.path)
}