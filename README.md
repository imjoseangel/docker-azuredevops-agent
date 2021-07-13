# Azure DevOps Agent on Docker

A Docker Azure DevOps image.

## Running

Run Azure DevOps Agent:

```shell
docker run -d -P --name vstsagent -e AZP_URL=https://<your_company>.visualstudio.com -e AZP_TOKEN=<your_token> -e AZP_AGENT_NAME=dockeragent -e AZP_POOL="Docker Linux Agent" --name agentvsts imjoseangel/vstsagent
```

Allocating a pseudo-TTY is not strictly necessary, but it gives us pretty color-coded logs that we can look at with `docker logs`:
   `-t`

## Maintainers

Maintained by [@imjoseangel](http://github.com/imjoseangel)

## License

Licensed under [The MIT License](LICENSE)
