FROM mcr.microsoft.com/windows/servercore:ltsc2019

LABEL maintainer="@imjoseangel"

WORKDIR /azp
COPY start.ps1 .

CMD powershell .\start.ps1
