# Task for Great iOS developer

If you found this task it means we are looking for you!

> Note: To clone this repository you will need [GIT-LFS](https://git-lfs.github.com/)

## Few simple steps

1. Fork this repo
2. Do your best
3. Prepare pull request and let us know that you are done

## Few simple requirements

- Send authorization request (POST) to http://playground.te`net.lt/v1/tokens to generate token with body: `{"username": "tesonet", "password": "partyanimal"}`. (Don't forget Content-Type) *
- Get servers list from http://playground.tesonet.lt/v1/servers. Add header to request: `Authorization: Bearer <token>` *
- Create persistant layer to store servers
- Design should be recreated as closely as possible

- Bonus: implement smooth animated transition from login through loader to server list screen
- Bonus: implement credential storage in keychain

* Handle 401 response