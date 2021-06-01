# Task for Great iOS developer

If you found this task it means we are looking for you!

> Note: To clone this repository you will need [GIT-LFS](https://git-lfs.github.com/)

## Few simple steps

1. Fork this repo
2. Do your best
3. Prepare pull request and let us know that you are done

## Few simple requirements

- Send authorization request (POST) to http://playground.tesonet.lt/v1/tokens to generate token with body: `{"username": "tesonet", "password": "partyanimal"}`. (Don't forget Content-Type) *
- Get servers list from http://playground.tesonet.lt/v1/servers. Add header to request: `Authorization: Bearer <token>` *
- Create persistant layer to store servers
- Design should be recreated as closely as possible

- Bonus: implement smooth animated transition from login through loader to server list screen
- Bonus: implement credential storage in keychain

* Handle 401 response


# Solution

## Notes for reviewes

- To make this task more practival I decided to try something new and my sight fell on [Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture). So it is the first trial of this architecture framework.
- To make my life slightly easier and save some time I asked @icanswiftabit a permission to reuse some code from his solution.
- I was focused on resolving architecture things rather than UI component, so no fancy animations and pixel perfect design. Anyway it could be added later on.
- Thanks for review, any comments and questions are very welcome!
