pipeline {
    agent any

    environment {

        GCP_PROJECT_ID = 'learndevops-418907'
        CLUSTER_NAME = 'my-gke-cluster'
    }
    


    stages {

        stage('Setup') {
            steps {
                // Set up Google Cloud SDK
                withCredentials([file(credentialsId: '9c8b661d-fa52-4921-a4f5-069f95abe3a6', variable: 'GOOGLE_CREDENTIALS')]) {
                    bat '''
                    gcloud config set project %GCP_PROJECT_ID%
                    gcloud container clusters get-credentials %CLUSTER_NAME% --zone us-central1-a
                    '''
                }
            }
        }
        
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

        stage('Deploy app') {
            steps {
                dir('Helm'){

                    withCredentials([file(credentialsId: 'kubernetes-config', variable: 'KUBECONFIG')]) {
                        
                        bat 'kubectl config use-context gke_learndevops-418907_us-central1_my-gke-cluster'
                        bat 'helm package currency-exchange-chart'
                        bat 'helm uninstall my-currency-exchange'
                        bat 'helm install my-currency-exchange ./currency-exchange-chart-0.1.0.tgz'
                    }
                    
                }
            }
        }

    }
}
