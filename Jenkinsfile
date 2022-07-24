pipeline {
    agent any
    environment {
        tag = sh(returnStdout: true, script: "git rev-parse --short=10 HEAD").trim()
        image = sh(returnStdout: true, script: "echo mdhack/react-test:${tag}").trim()
    }

    stages {
        stage('Build & Push') {
            steps {
                sh "docker build -t mdhack/react-test:${tag} ."
                withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'HUB_USER', passwordVariable: 'HUB_PASS')]) {
                    sh "echo ${HUB_PASS} | docker login -u ${HUB_USER} --password-stdin"
                    sh "docker push mdhack/react-test:${tag}"
                }
            }
        }
        
        stage("Update Tag") {
            steps {
                // sh "export IMAGE_NAME=mdhack/react-test:${tag}"
                // sh "echo $IMAGE_NAME"
                withCredentials([usernamePassword(credentialsId: 'git-creds', passwordVariable: 'GIT_PAT', usernameVariable: 'GIT_USERNAME')])  {
                    sh "git clone https://${GIT_USERNAME}:${GIT_PAT}@github.com/mdhack0316/react-deployment.git"
                    dir("react-deployment") {
                        sh 'git config --global user.email "mayank123modi@gmail.com"'
                        sh 'git config --global user.name "Mayank Modi"'
                        sh 'sed -i "s|mdhack/.*|${image}|" deployment.yaml'
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
    
