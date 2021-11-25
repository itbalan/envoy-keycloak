package envoy.authz

import input.attributes.request.http as http_request

default allow = {
	"allowed": false,
	"reason": "unauthorized resource access"
}

#default allowed_clients: false

allow {
#	is_token_valid
    action_allowed
}

#is_token_valid {
#  token.valid
#  now := time.now_ns() / 1000000000
#  token.payload.nbf <= now
#  now < token.payload.exp
#}

token := {"header": header, "payload": payload} {
    [_, encoded] := split(http_request.headers.authorization, " ")
    [header, payload, _] := io.jwt.decode(encoded)
}

#allowed_clients = true{token.payload.clientId == "partner-sys1"}

#allowed_clients = true{token.payload.clientId == "test"}

#Allow Partner1 to access only GET endpoints of test service
action_allowed {
  http_request.method == "GET"
#  http_request.headers.from == "partner-sys1"
  token.payload.clientId == "partner-sys1"
  token.payload.aud = "test-api"
  contains(token.payload.scope, "test-read")
  glob.match("/test*", [], http_request.path)
}

#Allow Partner1 to access only GET endpoints of test service
action_allowed {
  http_request.method == "GET"
#  http_request.headers.from == "partner-sys1"
#  token.payload.clientId == "partner-sys1"
  token.payload.aud = "test-api"
  contains(token.payload.scope, "test-read")
  token.payload.email == "itbalan@yahoo.com"
  glob.match("/test*", [], http_request.path)
}

#Allow Partner2 to access both GET/POST endpoints of test service
action_allowed {
  http_request.method == "GET"
#  http_request.headers.from == "partner2"
  token.payload.clientId == "partner-sys2"
  token.payload.aud = "test-api"
  contains(token.payload.scope, "test-read")
  glob.match("/test*", [], http_request.path)	
}

action_allowed {
  http_request.method == "POST"
#  http_request.headers.from == "partner2"
  token.payload.clientId == "partner-sys2"
  token.payload.aud = "test-api"
  contains(token.payload.scope, "test-create")
 glob.match("/test*", [], http_request.path)
}

#Allow all downstream systems to access both GET/POST endpoints of template service
action_allowed {
  http_request.method == "POST"
  glob.match("/template*", [], http_request.path)
}

action_allowed {
  http_request.method == "GET"
  glob.match("/template*", [], http_request.path)
}

action_allowed {
  http_request.method == "GET"
  glob.match("/actuator*", [], http_request.path)
}