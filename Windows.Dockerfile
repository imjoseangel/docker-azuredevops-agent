FROM mcr.microsoft.com/windows/servercore:ltsc2019

LABEL maintainer="@imjoseangel"

RUN @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

WORKDIR /azp
COPY start.ps1 .

CMD powershell .\start.ps1
