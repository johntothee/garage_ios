#  garage_ios

This swift project is a companion to to the node app at https://github.com/johntothee/garage. Garage runs on a raspberry pi connected to relays to drive a solenoid that blocks the track of a garage door and triggers the manual open-close of a garage door opener. It receives an rsa signed jwt token. Garage_ios sends creates and sends these tokens.

While the node app is ready for final testing, garage_ios is a work in progress. As a complete noob at swift it took several attempts to include the JWT package and its dependencies from the vapor project - (the only jwt library for swift that does rsa signing). Ultimately it modifying the repos added by cocoapods. I'll be submitting pull requests to those vapor projects shortly.

Credential fields are not yet saving correctly. Actually creating the token and sending it isn't implemented yet either.
