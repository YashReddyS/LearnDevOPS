pipeline {
    agent any

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
                    // Replace 'your-secret-id' with the actual ID of your secret in Jenkins
                    withKubeConfig([credentialsId: 'kubernetes-config']) {
                        bat 'gcloud components install gke-gcloud-auth-plugin'
                        dir('Helm'){
                            bat 'helm package currency-exchange-chart'
                            bat 'helm install my-currency-exchange ./currency-exchange-chart-0.1.0.tgz'
                                
                            }
                    }
                }
            }
        }
        stage('Set KUBECONFIG') {
            steps {
                script {
                    // Set the KUBECONFIG environment variable
                    bat "SETX KUBECONFIG \"${env.WORKSPACE}\\secret.yaml\""
                }
            }
        }
        stage('Verify KUBECONFIG') {
            steps {
                script {
                    // Print the value of KUBECONFIG for verification
                    bat "echo %KUBECONFIG%"
                }
            }
        }

        stage('Deploy app') {
            steps {
                dir('Helm'){
                    bat 'helm package currency-exchange-chart'
                    bat 'helm install my-currency-exchange ./currency-exchange-chart-0.1.0.tgz'
                                
                }
            }
        }

        

    }
}
