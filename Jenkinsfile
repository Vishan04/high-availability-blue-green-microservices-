pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Validate Project') {
            steps {
                bat 'docker --version'
                bat 'kubectl version --client'
                bat 'terraform version'
            }
        }

        stage('Build Docker Images') {
            steps {
                bat 'docker build -t blue-green-frontend:v2 ./frontend'
                bat 'docker build -t blue-green-product-service:v2 ./product-service'
            }
        }

        stage('Terraform Plan') {
            steps {
                bat 'cd terraform && terraform init'
                bat 'cd terraform && terraform plan'
            }
        }
    }
}