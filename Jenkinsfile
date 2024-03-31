pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS = credentials('Docker-credentials')
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the Terraform scripts from your repository
                checkout scm
            }
        }

        stage('Build docker image') {
            steps {
                // Change to the desired directory
                dir('Source\\currency-exchange-service') {
                    bat 'mvn spring-boot:build-image -DskipTests'
                }
            }
        }

        stage('Push docker image to docker Hub') {
            steps {
              bat 'docker login'  
            }
        }

        stage('Apply Terraform') {
            steps {
                // Apply the Terraform scripts to create the GKE cluster
                dir('Terraform'){
                    withCredentials([file(credentialsId: '9c8b661d-fa52-4921-a4f5-069f95abe3a6', variable: 'GOOGLE_CREDENTIALS')]) {
                        bat 'echo "hello"'
                        bat 'terraform init'
                        bat 'set GOOGLE_CREDENTIALS=%GOOGLE_CREDENTIALS%'
                        bat 'terraform apply -auto-approve'
                    }  
                }
            }
        }
    }
}
