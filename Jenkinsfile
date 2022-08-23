pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
        AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')
        TF_VAR_env_prefix = 'dev'
        TF_VAR_ssh_public_key = '/var/jenkins_home/.ssh/id_rsa.pub'
        DOCKER_CREDS = credentials('docker-credentials')
        IMAGE_NAME = "towhidk2/nodeapp:${BUILD_NUMBER}"

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
                    echo "Building and pushing image to docker hub..."
                    sh "docker build -t ${IMAGE_NAME} ."
                    sh "echo ${DOCKER_CREDS_PSW} | docker login -u ${DOCKER_CREDS_USR} --password-stdin"
                    sh "docker push ${IMAGE_NAME}"
                }
            }
        }


        stage('Provision server and create AMI') {
            
            stages {

                stage('Provision server') {
                    steps {
                        script {
                            dir('terraform-ami') {
                                echo 'Provisioning server...'
                                sh "terraform init"
                                sh "terraform plan"
                                sh "terraform apply --auto-approve"
                            }
                        }
                    }
                }

                stage('Configure server') {
                    steps {
                        script {
                            dir('ansible') {
                                echo 'Configuring server...'
                                sh "ansible-playbook deploy-docker-container.yaml --vault-password-file $HOME/.vault_secret --extra-vars image_tag=${BUILD_NUMBER}"
                            }
                        }
                    }
                }

                stage('Create custom AMI') {
                    steps {
                        script {
                            dir('terraform-ami') {
                                echo 'Creatiing AMI...'
                                sh "python3 create_custom_ami.py"
                            }
                        }
                    }
                }

                stage('Destroy provisioned server') {
                    steps {
                        script {
                            dir('terraform-ami') {
                                echo 'Destroying provisioned server...'
                                sh "terraform destroy --auto-approve"
                            }
                        }
                    }
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