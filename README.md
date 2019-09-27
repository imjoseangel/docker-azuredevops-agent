[![Get your own image badge on microbadger.com](https://images.microbadger.com/badges/image/imjoseangel/docker-vstsagent.svg)](https://microbadger.com/images/imjoseangel/docker-vstsagent "Get your own image badge on microbadger.com")

## Azure DevOps Agent on Docker

A Docker Azure VSTS (DevOps) image.

### Running

Run Azure DevOps Agent with a random port:

```shell
docker run -d -P --name vstsagent -e AZP_URL=https://<your_company>.visualstudio.com -e AZP_TOKEN=<your_token> -e AZP_AGENT_NAME=dockeragent -e AZP_POOL="Docker Linux Agent" --name agentvsts imjoseangel/vstsagent
```

or map to exposed port 8080:

```shell
docker run -d --name vstsagent -e AZP_URL=https://<your_company>.visualstudio.com -e AZP_TOKEN=<your_token> -e AZP_AGENT_NAME=dockeragent -e AZP_POOL="Docker Linux Agent" -p 8080:8080 --name agentvsts imjoseangel/vstsagent
```

Allocating a pseudo-TTY is not strictly necessary, but it gives us pretty color-coded logs that we can look at with `docker logs`:
   `-t`

### K8S Heath Check

**URL:** `https://localhost/health`

### License

Copyright © 2019 [imjoseangel](http://imjoseangel.github.com). Licensed under [the MIT license](https://github.com/imjoseangel/docker-tower/blob/master/LICENSE).
