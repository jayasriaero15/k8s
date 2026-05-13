pipeline {
    agent any
    tools {
        maven 'maven3'
    }
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/jayasriaero15/k8s.git'
            }
        }

        stage('Build') {
            steps {
                bat 'mvn clean package -DskipTests'
            }
        }

        stage('Authenticate to GCP via WIF') {
            steps {
                withCredentials([file(credentialsId: 'gcp-wif-cred', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                    bat '''
                        echo Authenticating to Google Cloud using Workload Identity Federation...
                        gcloud auth login --cred-file=%GOOGLE_APPLICATION_CREDENTIALS%
                        gcloud auth configure-docker asia-south2-docker.pkg.dev --quiet
                        gcloud config set project project-af5a9a8c-a838-417b-891
                        gcloud auth list
                    '''
                }
            }
        }

        stage('Docker Build') {
            steps {
                bat 'docker build -t asia-south2-docker.pkg.dev/project-af5a9a8c-a838-417b-891/myrepo/myapp:%BUILD_NUMBER% .'
            }
        }

        stage('Push Image') {
            steps {
                bat 'docker push asia-south2-docker.pkg.dev/project-af5a9a8c-a838-417b-891/myrepo/myapp:%BUILD_NUMBER%'
            }
        }

        stage('Helm Lint') {
            steps {
                bat 'helm lint charts/myapp'
            }
        }

        stage('Publish Helm Chart') {
            steps {
                bat 'helm package charts/myapp && helm push myapp-*.tgz oci://asia-south2-docker.pkg.dev/project-af5a9a8c-a838-417b-891/charts'
            }
        }

        stage('Deploy to GKE') {
            steps {
                bat 'helm upgrade --install myapp charts/myapp --namespace prod --set image.tag=%BUILD_NUMBER%'
            }
        }
    }

    post {
        success {
            echo '✅ Build, authentication, and deployment successful!'
        }
        failure {
            echo '❌ Pipeline failed. Check logs for details.'
        }
    }
}

