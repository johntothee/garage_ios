#  garage_ios

This swift project is a companion to the node app at https://github.com/johntothee/garage. Garage runs on a raspberry pi connected to relays to drive a solenoid that blocks the track of a garage door and triggers the manual open-close buton of a garage door opener. It receives an RSA signed JWT token. 

Garage_ios creates and sends these tokens. To setup add the url, port, apikey string, and private key to the app. The final parameter of a request is a time stamped JWT token signed with the private key. The token also contains either the command "verify" or "open-close". Verify is for testing purposes to ensure everything is communicating properly. While the content of the token can be unencoded and read, only the public key can verify the signature.

Requests are sent to https://[url]/api/garage:[port]?apiKey=[apikey]&token=[signed_jwt_token]
