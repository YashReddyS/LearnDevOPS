pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Checkout the Terraform scripts from your repository
                checkout scm
            }
        }

        stage('Init Terraform') {
            steps {
                // Initialize Terraform
                bat 'terraform init'
            }
        }

        stage('Apply Terraform') {
            steps {
                // Apply the Terraform scripts to create the GKE cluster
                withCredentials([file(credentialsId: '9c8b661d-fa52-4921-a4f5-069f95abe3a6', variable: 'GOOGLE_CREDENTIALS')]) {
                    bat 'echo "hello"'
                    bat 'set GOOGLE_CREDENTIALS=%GOOGLE_CREDENTIALS%'
                    bat 'terraform apply -auto-approve'
                }  
                
            }
        }
    }
}
