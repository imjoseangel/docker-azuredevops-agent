#!/bin/bash
set -e

print_header() {
  lightcyan='\033[1;36m'
  nocolor='\033[0m'
  echo -e "${lightcyan}$1${nocolor}"
}

cd /azp
azptoken=$(cat /azp/.token)

print_header "Cleanup. Removing Azure Pipelines agent..."

./config.sh remove --unattended --auth PAT --token "$azptoken"
