pipeline {
  environment {
    registry = '890769921003.dkr.ecr.eu-central-1.amazonaws.com/pscibisz-db'
    registryCredential = 'aws-kredki'
    dockerImage = ''
    tag = sh(returnStdout: true, script: "git ls-remote https://github.com/scibiszPiotr/upskill_db.git rev-parse --short=10 HEAD | cut -c 1-10").trim()
  }
  agent any
  stages {
    stage ('Git clone') {
        steps {
            git url: "https://github.com/scibiszPiotr/upskill_db.git", branch: 'main'
        }
    }
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build registry + ":" + tag
        }
      }
    }
    stage('Deploy image') {
        steps{
            script{
                docker.withRegistry("https://" + registry, "ecr:eu-central-1:" + registryCredential) {
                    dockerImage.push()
                }
            }
        }
    }
  }
}