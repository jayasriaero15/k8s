pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/jayasriaero15/k8s.git'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        stage('Docker Build') {
            steps {
                sh 'docker build -t gcr.io/project-af5a9a8c-a838-417b-891/myapp:$BUILD_NUMBER .'
            }
        }
        stage('Push Image') {
            steps {
                sh 'docker push gcr.io/project-af5a9a8c-a838-417b-891/myapp:$BUILD_NUMBER'
            }
        }
        stage('Helm Lint') {
            steps {
                sh 'helm lint charts/myapp'
            }
        }
        stage('Publish Helm Chart') {
            steps {
                sh 'helm package charts/myapp && helm push myapp-*.tgz oci://gcr.io/project-af5a9a8c-a838-417b-891/charts'
            }
        }
	stage('Deploy to GKE') {
	    steps {
    		sh 'helm upgrade --install myapp charts/myapp --namespace prod --set image.tag=${BUILD_NUMBER}'
	    }
	}

    }
    post {
        success {
            echo 'Build and push successful!'
        }
    }
}

