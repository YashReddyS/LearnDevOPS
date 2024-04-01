pipeline {
    agent any

    environment {
        GOOGLE_PROJECT = 'learndevops-418907'
        GOOGLE_CLUSTER_NAME = 'my-gke-cluster'
        GOOGLE_ZONE = 'us-central1-f'
        
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

        stage('Retrieve Secret') {
            steps {
        
                 script {
                    withCredentials([file(credentialsId: '9c8b661d-fa52-4921-a4f5-069f95abe3a6', variable: 'GCP_CREDS_JSON')]) {
                        bat """
                            echo %GCP_CREDS_JSON% > %HOMEDRIVE%%HOMEPATH%\\gcloud-service-key.json
                            gcloud auth activate-service-account --key-file=%HOMEDRIVE%%HOMEPATH%\\gcloud-service-key.json
                            gcloud container clusters get-credentials $GOOGLE_CLUSTER_NAME --zone $GOOGLE_ZONE --project $GOOGLE_PROJECT
                        """
                    }
                }
                         
            }
        }
        
        

    }
}
