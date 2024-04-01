pipeline {
    agent any

    environment {
        GOOGLE_APPLICATION_CREDENTIALS = credentials('9c8b661d-fa52-4921-a4f5-069f95abe3a6')
    }

    stages{

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
                      withCredentials([usernamePassword(credentialsId: 'Docker-credentials', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
                      bat "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
                      bat  "docker tag yashwanthreddysamala/mmv3-currency-exchange-service:0.0.12-SNAPSHOT yashwanthreddysamala/mmv3-currency-exchange-service:Latest"
                      bat 'docker push yashwanthreddysamala/mmv3-currency-exchange-service:Latest'
                }
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

        stage('deploy app') {
            steps {
                dir('Helm'){
                    bat """
                    gcloud auth activate-service-account --key-file=%GOOGLE_APPLICATION_CREDENTIALS%
                    gcloud config set project learndevops-418907
                    'gcloud container clusters get-credentials my-gke-cluster --region us-central1 --project learndevops-418907'
                    
                    set RELEASE_NAME=my-currency-exchange
                    set CHART_PATH=./currency-exchange-chart-0.1.0.tgz
                    
                    REM Check if the release already exists
                    helm status %RELEASE_NAME% 2>nul
                    if %errorlevel% equ 0 (
                      REM Release exists, perform upgrade
                      helm upgrade %RELEASE_NAME% %CHART_PATH%
                    ) else (
                      REM Release doesn't exist, perform installation
                      helm install %RELEASE_NAME% %CHART_PATH%
                    )
                    """
                }
            }
        }
        
    }
}
