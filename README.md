
# Completed Task

A simple demo iOS app that displays a list of servers after a login.

> Note: To clone this repository you will need [GIT-LFS](https://git-lfs.github.com/)

## Features

- Support from iOS 11
- Dark Mode Support on iOS 13
- Pull Down to Refresh Server List
- Automatic Re-login For Expired Tokens
- Credential and Token Storage in Keychain
- Persistence for Offline Display
- Simple Custom Transition Animations

## Original Requirements

- Send authorization request (POST) to `http://playground.tenet.lt/v1/tokens` to generate token with body: `{"username": "tesonet", "password": "partyanimal"}`. (Don't forget Content-Type) *
- Get servers list from http://playground.tesonet.lt/v1/servers. Add header to request: `Authorization: Bearer <token>` *
- Create persistant layer to store servers
- Design should be recreated as closely as possible

- Bonus: implement smooth animated transition from login through loader to server list screen
- Bonus: implement credential storage in keychain

* Handle 401 response
