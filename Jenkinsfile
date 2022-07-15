pipeline {
    agent any
    environment {
        tag = sh(returnStdout: true, script: "git rev-parse --short=10 HEAD").trim()
        image = sh(returnStdout: true, script: "echo amiharsh/react-test:${tag}").trim()
    }

    stages {
        stage('Build & Push') {
            steps {
                sh 'git submodule init'
                sh 'git submodule update'
                sh "docker build -t amiharsh/react-test:${tag} ."
                withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'HUB_USER', passwordVariable: 'HUB_PASS')]) {
                    sh "echo ${HUB_PASS} | docker login -u ${HUB_USER} --password-stdin"
                    sh "docker push amiharsh/react-test:${tag}"
                }
            }
        }
        
        stage("Update Tag") {
            steps {
                // sh "export IMAGE_NAME=amiharsh/react-test:${tag}"
                // sh "echo $IMAGE_NAME"
                withCredentials([usernamePassword(credentialsId: 'git-creds', passwordVariable: 'GIT_PAT', usernameVariable: 'GIT_USERNAME')])  {
                    sh "git clone https://${GIT_USERNAME}:${GIT_PAT}@github.com/amiharsh/react-deployment.git"
                    dir("react-deployment") {
                        sh 'git config --global user.email "hvkataria12@gmail.com"'
                        sh 'git config --global user.name "Harsh Vardhan"'
                        sh 'sed -i "s|amiharsh/.*|${image}|" deployment.yaml'
                        sh "git add ."
                        sh "git commit -m ${image}"
                        sh "git push"
                    }
                }
            }
        }
    }
    post {
        always {
            script {
                dir("${env.WORKSPACE}") {
                    sh "rm -rf react-deployment" 
                }
            }
        }
    }
}
    