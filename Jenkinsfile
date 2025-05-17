pipeline {
    agent {
            label 'agent'
    }
    options {
        timeout(time: 30, unit: 'MINUTES')
        disableConcurrentBuilds()
        ansiColor('xterm')
    }
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        AWS_EC2_INSTANCE_IP = '184.73.117.186'
        AWS_SSH_KEY = credentials('https-key')
        DOCKER_IMAGE = 'bhavyasomisetti/frontend-app'
        IMAGE_VERSION = "${env.BUILD_NUMBER}"
        DOCKER_REGISTRY = 'https://index.docker.io/v1/'
        HOST_PORT = '8000'
        #SSH_USER = 'ec2-user'  // Added this missing variable
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/BhavyaAudisri/frontend-app.git'
            }
        }
        
         stage('Build & Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
                    script {
                        sh """
                        docker build -t ${DOCKER_IMAGE}:${IMAGE_VERSION} .
                        echo "${DOCKERHUB_PASS}" | docker login -u "${DOCKERHUB_USER}" --password-stdin
                        docker push ${DOCKER_IMAGE}:${IMAGE_VERSION}
                        """
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    withCredentials([sshUserPrivateKey(
                        credentialsId: 'https-key',
                        keyFileVariable: 'SSH_KEY',
                        usernameVariable: 'SSH_USER'
                    )]) {
                        sh """
                        ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${SSH_USER}@${AWS_EC2_INSTANCE_IP} '
                            docker stop sample-frontend || true
                            docker rm sample-frontend || true
                            docker pull ${DOCKER_IMAGE}:${IMAGE_VERSION}
                            docker run -d --name sample-frontend --restart unless-stopped -p ${HOST_PORT}:80 -e IMAGE_VERSION=${IMAGE_VERSION} ${DOCKER_IMAGE}:${IMAGE_VERSION}
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
