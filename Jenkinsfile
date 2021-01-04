pipeline {
  agent {
    kubernetes {
      // Use Kubernetes to build our images.
      // Use Kaniko instead of docker so we can build images without access to docker.
      // Note that you must have the secret docker-credentials in your namespace.
      defaultContainer 'kaniko'
      yaml """
kind: Pod
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:latest
    imagePullPolicy: Always
    command:
    - sleep
    args:
    - 9999999
    volumeMounts:
      - name: jenkins-docker-cfg
        mountPath: /kaniko/.docker
  volumes:
  - name: jenkins-docker-cfg
    projected:
      sources:
      - secret:
          name: docker-credentials
          items:
            - key: .dockerconfigjson
              path: config.json
"""
    }
  }
  environment {
      // Grab our Nirmata Token from Jenkins creds
      NIRMATA_TOKEN     = credentials('NIRMATA_TOKEN')
      // This needs to be changed if you are using Nirmata PE
      NIRMATA_URL       = 'https://nirmata.io'
      // This should be your locally cached copy
      NCTL_URL          = 'https://nirmata-downloads.s3.us-east-2.amazonaws.com/nctl/nctl_3.1.0-rc2/nctl_3.1.0-rc2_linux_64-bit.zip'
      // The rest should changed to your app and repo.
      DOCKER_REPO       = 'ssilbory/alpine-tomcat'
      APP_NAME          = 'alpine-tomcat'
      ENV_NAME          = 'tomcat'
      YAML_FILE         = 'tomcat.yaml'
  }
  stages {
    stage('Build with Kaniko') {
      // You might want to break this into multiple stages
      steps {
        // Get our git repo
        git 'https://github.com/silborynirmata/jekins-example.git'
        //
        sh "/kaniko/executor --context `pwd` --destination ${DOCKER_REPO}:${env.BUILD_ID}"
        sh "sed  s/:latest/:${env.BUILD_ID}/ -i ${YAML_FILE}"
        sh '''if command -v nctl ;then
                nctl environments apps apply ${APP_NAME} -e ${ENV_NAME} -f ${YAML_FILE}
              else
                if [ -f nctl ];then
                  chmod +x nctl
                else
                  wget -O nctl.zip ${NCTL_URL}
                  unzip -o nctl.zip
                  chmod 500 nctl
                fi
                # Your app must exist in Nirmata
                ./nctl environments apps apply ${APP_NAME} -e ${ENV_NAME} -f ${YAML_FILE}
              fi'''
      }
    }
  }
}
