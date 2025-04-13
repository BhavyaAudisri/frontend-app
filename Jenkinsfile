pipeline {
    agent any
    
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        AWS_EC2_INSTANCE_IP = '54.174.227.8'
        AWS_SSH_KEY = credentials('https-key')
        DOCKER_IMAGE = 'sinha352/frontend-app'
        IMAGE_VERSION = "${env.BUILD_NUMBER}"
        DOCKER_REGISTRY = 'https://index.docker.io/v1/'
        HOST_PORT = '8000'
        SSH_USER = 'ubuntu'  // Added this missing variable
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/vijay2181/frontend-app.git'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                    docker build -t ${DOCKER_IMAGE}:${IMAGE_VERSION} .
                    docker login -u sinha352 -p 2019
                    docker push ${DOCKER_IMAGE}:${IMAGE_VERSION}
                    """
                }
            }
        }
       
        stage('Deploy to EC2') {  // Renamed from 'Verify Deployment'
            steps {
                script {
                    withCredentials([sshUserPrivateKey(
                        credentialsId: 'https-key',
                        keyFileVariable: 'SSH_KEY',
                        usernameVariable: 'SSH_USER'  // This will provide the username
                    )]) {
                        sh """
                        # Deploy to target server
                        ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${SSH_USER}@${AWS_EC2_INSTANCE_IP} '
                            docker stop sample-frontend || true
                            docker rm sample-frontend || true
                        
                            # Pull the new image
                            docker pull ${DOCKER_IMAGE}:${IMAGE_VERSION}
                        
                            # Run the new container
                            docker run -d \\
                                --name sample-frontend \\
                                --restart unless-stopped \\
                                -p ${HOST_PORT}:80 \\
                                -e IMAGE_VERSION=${IMAGE_VERSION} \\
                                ${DOCKER_IMAGE}:${IMAGE_VERSION}
                        '
                        """
                    }
                }
            }
        }
    }
    
    post {
        always {
            sh """
            # Cleanup Docker artifacts
            docker system prune -af --filter "until=24h"
            """
        }
    }
}
