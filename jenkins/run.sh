#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"

### Get user/token ###
echo "Enter your Jenkins user:"
read user
echo "Enter your Jenkins password:"
read token

### Get CRUMB ###
echo -e "\nGet CRUMB"
CRUMB=$(curl -s "http://$user:$token@localhost:8080/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)")
echo -e "\n$CRUMB"

### Install Docker plugin ###
echo -e "\nInstall docker plugin"
curl -X POST -H "$CRUMB" -u $user:$token -d '<jenkins><install plugin="docker-build-publish@latest" /></jenkins>' --header 'Content-Type: text/xml' http://localhost:8080/pluginManager/installNecessaryPlugins

curl -sO http://localhost:8080/jnlpJars/jenkins-cli.jar

### Create Credential ###
echo -e "\nCreate credential for job"
curl -X POST -H "$CRUMB" -u $user:$token 'http://localhost:8080/credentials/store/system/domain/_/createCredentials' \
--data-urlencode 'json={
  "": "0",
  "credentials": {
    "scope": "GLOBAL",
    "id": "0c274f0f-d3f8-466b-af8e-06c4d957e29e",
    "username": "mevdevopstest",
    "password": "pass1815",
    "description": "",
    "$class": "com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl"
  }
}'

### Import Job ###
echo -e "\nImport job"
cat job.xml | java -jar jenkins-cli.jar -auth $user:$token -s http://localhost:8080/ create-job docker-build

### Restart Jenkins ###
echo -e "\nRestart Jenkins"
java -jar jenkins-cli.jar -auth $user:$token -s http://localhost:8080/ safe-restart
