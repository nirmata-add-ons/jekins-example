# Using Jenkins file

This repo contains an example of using Nirmata and nctl to deploy a simple tomcat app.  It makes use of Kaniko to build in a container without needing access to the docker daemon.
https://github.com/GoogleContainerTools/kaniko

To use
- Install or otherwise get access to Jenkins.
- Create a API Key in Nirmata and create a secret text credentials called NIRMATA_TOKEN accessable by your Jenkins pipeline. (settings->profile)
- Create a docker secret with your docker login called docker-credentials. Alternately pass this as a Jenkin credential*.
"kubectl create secret docker-registry --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-pword> --docker-email=<your-email> --dry-run -o yaml >docker-credentials.yaml"
https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/#registry-secret-existing-credentials
- Use the Jenkinsfile to create the pipelineand adjust the varibles in the environment secition to match your apps, and Nirmata installation.


*To use a jenkins credential for docker repo access you will need to
- Create a file /kaniko/.docker/config.json with user and password for your docker repo using your docker repo creds.  Example
'''echo "{\"auths\":{\"$REGISTRY\":{\"username\":\"${REGISTRY_USER}\",\"password\":\"${REGISTRY_PASSWORD}\"}}}" > /kaniko/.docker/config.json'''
- Remove the volume and volume mount section from the pod template.


# Example Scripts for nctl
- update-app.sh           Updates a running app.
- update-catalog-app.sh   Updates a catalog app.
- create-app.sh           Creates a running app.
- create-catalog-app.sh   Create a catalog app.


# Jenkins Setup
- Import jenkins helm repo Catalog -> Helm -> Add Helm Repo use https://charts.jenkins.io
- Import Jenkins chart to a catalog app named jenkins.
- Edit application and select Other category.
- Download and Import SA yaml for cluster access.
https://raw.githubusercontent.com/jenkins-infra/jenkins.io/master/content/doc/tutorials/kubernetes/installing-jenkins-on-kubernetes/jenkins-sa.yaml 
- Deploy as a standard app or as an addon.  Note that you will need to be an admin and the namespace must be jenkins unless you modify all the namespace refernces.
- Login into Jenkins UI with password stored in the key jenkins-admin-password in the secret-latest-jenkins secret.
- Update plugins
- Create a secret text credentials called NIRMATA_TOKEN accessable by your Jenkins pipeline.
