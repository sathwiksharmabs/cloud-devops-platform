pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ECR_REGISTRY = '472981659331.dkr.ecr.us-east-1.amazonaws.com'
        ECR_REPOSITORY = 'dev/cloud-devops-platform'
        IMAGE_NAME = 'cloud-devops-platform'
        IMAGE_TAG = "jenkins-${BUILD_NUMBER}"
        ECR_IMAGE = "${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}"
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

        stage('Docker Image Verify') {
            steps {
                sh '''
                    docker image inspect ${IMAGE_NAME}:${IMAGE_TAG} \
                      --format "{{.Id}} | {{.Config.User}} | {{.Config.Entrypoint}}"
                '''
            }
        }

        stage('ECR Push') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'jenkins-aws',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    sh '''
                        set +x

                        aws ecr get-login-password \
                          --region "$AWS_REGION" \
                          | docker login \
                              --username AWS \
                              --password-stdin "$ECR_REGISTRY"

                        docker tag \
                          "${IMAGE_NAME}:${IMAGE_TAG}" \
                          "$ECR_IMAGE"

                        docker push "$ECR_IMAGE"

                        docker logout "$ECR_REGISTRY"
                    '''
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'jenkins-aws',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    sh '''
                        set +x

                        aws eks update-kubeconfig \
                          --region "$AWS_REGION" \
                          --name dev-eks \
                          --kubeconfig /tmp/jenkins-kubeconfig

                        export KUBECONFIG=/tmp/jenkins-kubeconfig

                        kubectl set image deployment/cloud-devops-platform \
                          cloud-devops-platform="$ECR_IMAGE" \
                          -n default

                    '''
                }
            }
        }

        stage('Rollout Verification') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'jenkins-aws',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    sh '''
                        set +x

                        export KUBECONFIG=/tmp/jenkins-kubeconfig

                        kubectl rollout status \
                          deployment/cloud-devops-platform \
                          -n default \
                          --timeout=180s

                        kubectl get deployment cloud-devops-platform \
                          -n default

                        kubectl get pods \
                          -n default \
                          -l app=cloud-devops-platform \
                          -o wide
                    '''
                }
            }
        }

        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }
    }
}