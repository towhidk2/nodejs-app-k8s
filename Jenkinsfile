pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
        AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')
        IMAGE_NAME = "235639604932.dkr.ecr.us-east-1.amazonaws.com/nodeapp:${BUILD_NUMBER}"

    }
    stages {
        
        stage('Build') {
            steps {
                script {
                    echo 'Building application...'
                    sh "npm install"
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    echo 'Testing application...'
                    sh "npm run test"
                }
            }
        }

        stage('Code analysis with sonarqube') {
            steps {
                script {
                    echo 'Analyzing code...'
                    sh "npm install sonar-scanner"
                    sh "npm run sonar"
                }
            }
        }

        stage('Build and push image') {
            steps {
                script {
                    echo "Building and pushing image to aws ecr..."
                    sh "docker build -t ${IMAGE_NAME} ."
                    sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 235639604932.dkr.ecr.us-east-1.amazonaws.com"
                    sh "docker push ${IMAGE_NAME}"
                }
            }
        }      
    
        stage('Deploy MyApp') {
            steps {
                script {
                    dir('k8s') {
                        echo 'deploying the nodeapp...'
                        sh "sed -i 's/tag_name/${BUILD_NUMBER}/g' nodeapp.yaml"
                        sh "kubectl apply -f nodeapp.yaml"
                    }
                }
            }
        }

        // stage('Destroy') {
        //     steps {
        //         script {
        //             dir('terraform') {
        //                 echo "Destroying infrastructure..."
        //                 sh "terraform destroy --auto-approve"
        //             }
        //         }
        //     }
        // }

    }

    post { 
        always {
            slackSend channel: 'mytestchn', message: "Please find the status of pipeline\nStatus: ${currentBuild.currentResult}\nJob Name: ${env.JOB_NAME}\nBuild Number: ${env.BUILD_NUMBER}\nBuild URL: ${env.BUILD_URL}"
        }
    }

}