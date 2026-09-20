pipeline {
    agent any
    
    environment {
        IMAGE_NAME = 'cloud-devops-platform'
        IMAGE_TAG = "jenkins-${BUILD_NUMBER}"
    }

    stages {

        stage('Build') {
            steps {
                sh './mvnw clean compile'
            }
        }

        stage('Test') {
            steps {
                sh './mvnw test'
            }
        }

        stage('Package') {
            steps {
                sh './mvnw package -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'
            }
        }

        stage('Docker Image Info') {
            steps {
                sh 'docker image inspect ${IMAGE_NAME}:${IMAGE_TAG} --format "{{.Id}} | {{.Config.User}} | {{.Config.Entrypoint}}"'
            }
        }

        stage('Docker Image Verify') {
            steps {
                sh 'docker images cloud-devops-platform --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}"'
            }
        }

        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }
    }
}