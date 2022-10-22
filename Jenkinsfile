pipeline {
  environment {
    registry = '890769921003.dkr.ecr.eu-central-1.amazonaws.com/pscibisz-db'
    registryS3 = '890769921003.dkr.ecr.eu-central-1.amazonaws.com/pscibisz-web-s3'
    registryCredential = 'aws-kredki'
    tagDb = sh(returnStdout: true, script: "git ls-remote https://github.com/scibiszPiotr/upskill_db.git rev-parse --short=10 HEAD | cut -c 1-10").trim()
    tagS3 = sh(returnStdout: true, script: "git ls-remote https://github.com/scibiszPiotr/upskill_s3.git rev-parse --short=10 HEAD | cut -c 1-10").trim()
  }
  agent any
  tools {
       terraform 'terraform'
    }
  stages {
  stage('Terraform init') {
          steps{
              script {
                  dir('terraform') {
                      git url: "https://github.com/scibiszPiotr/terraform.git", branch: 'master'
                      sh 'terraform init'
                  }
              }
          }
      }
    stage ('Git clone db') {
        steps {
            sh "mkdir -p build"
            dir('build') {
                git url: "https://github.com/scibiszPiotr/upskill_db.git", branch: 'master'
            }
        }
    }
    stage ('Git clone s3') {
        steps {
            sh "mkdir -p build-s3"
            dir('build-s3') {
                git url: "https://github.com/scibiszPiotr/upskill_s3.git", branch: 'master'
            }
        }
    }
    stage('Building image db') {
      steps{
        script {
            dir('build') {
                dockerImageDb = docker.build registry + ":" + tagDb
            }
        }
      }
    }
    stage('Building image S3') {
      steps{
        script {
            dir('build-s3') {
                dockerImageS3 = docker.build registryS3 + ":" + tagS3
            }
        }
      }
    }
    stage('Deploy image db') {
        steps{
            script{
                docker.withRegistry("https://" + registry, "ecr:eu-central-1:" + registryCredential) {
                    dockerImageDb.push()
                }
            }
        }
    }
    stage('Deploy image s3') {
        steps{
            script{
                docker.withRegistry("https://" + registryS3, "ecr:eu-central-1:" + registryCredential) {
                    dockerImageS3.push()
                }
            }
        }
    }
    stage('Terraform apply') {
        steps{
            script {
                dir('terraform') {
                    git url: "https://github.com/scibiszPiotr/terraform.git", branch: 'master'
                    sh "terraform apply -auto-approve -var 'APP_DB_TAG=${tagDb}' -var 'APP_S3_TAG=${tagS3}' -var 'AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}' -var 'AWS_SECRET_ACCESS_KEY=AWS_SECRET_ACCESS_KEY'"
                }
            }
        }
    }
  }
}
