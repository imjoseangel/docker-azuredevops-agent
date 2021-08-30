# escape=`

# Base Image Windows Server Core image with .NET Framework 4.8.
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019

# **********************************************
# Install VS Build Tools
# **********************************************
# Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

RUN `
    # Download the Build Tools bootstrapper.
    curl -SL --output vs_buildtools.exe https://aka.ms/vs/16/release/vs_buildtools.exe `
    `
    # Install Build Tools with the Microsoft.VisualStudio.Workload.AzureBuildTools workload, excluding workloads and components with known issues.
    #https://docs.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-build-tools?view=vs-2019
    && (start /w vs_buildtools.exe --quiet --wait --norestart --nocache modify `
    --installPath "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\BuildTools" `
    --add Microsoft.VisualStudio.Workload.AzureBuildTools `
    --add Microsoft.VisualStudio.Workload.DataBuildTools `
    --add Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools `
    --add Microsoft.VisualStudio.Workload.MSBuildTools `
    --add Microsoft.VisualStudio.Workload.NetCoreBuildTools `
    --add Microsoft.VisualStudio.Workload.NodeBuildTools `
    --add Microsoft.VisualStudio.Workload.UniversalBuildTools `
    --add Microsoft.VisualStudio.Workload.WebBuildTools `
    || IF "%ERRORLEVEL%"=="3010" EXIT 0) `
    `
    # Cleanup
    && del /q vs_buildtools.exe


# **********************************************
# Install .net 3.5
# **********************************************

RUN curl -fSLo microsoft-windows-netfx3.zip https://dotnetbinaries.blob.core.windows.net/dockerassets/microsoft-windows-netfx3-1809.zip `
    && tar -zxf microsoft-windows-netfx3.zip `
    && del /F /Q microsoft-windows-netfx3.zip `
    && DISM /Online /Quiet /Add-Package /PackagePath:.\microsoft-windows-netfx3-ondemand-package~31bf3856ad364e35~amd64~~.cab `
    && del microsoft-windows-netfx3-ondemand-package~31bf3856ad364e35~amd64~~.cab `
    && powershell Remove-Item -Force -Recurse ${Env:TEMP}\*

# **********************************************
# Install choco
# **********************************************

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Allow installing without asking
RUN choco feature enable -n allowGlobalConfirmation

# suppress the "restart required" error code (3010)
# RUN choco install -y --ignore-package-exit-codes=3010 dotnetfx

# **********************************************
# Install choco 2
# **********************************************

#DB Componets
RUN choco install openjdk -dv -y;

#Other components
RUN choco install git -y;
RUN choco install osquery --version 3.4.0 -y;

# **********************************************
# Azure Devops Agents
# **********************************************

WORKDIR /azp
COPY start.ps1 .

CMD powershell .\start.ps1

# Define the entry point for the docker container.
# This entry point starts the developer command prompt and launches the PowerShell shell.
# SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
# ENTRYPOINT ["C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\BuildTools\\Common7\\Tools\\VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]
