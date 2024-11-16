pipeline {
    agent {label 'terraform-agent'}

    

    environment {
        aws_account_id = '471112682780'
        region    = 'us-east-1'
        ECR_REPO_NAME = 'infosysdemo/custome-nginx'
        cluster = 'my-cluster'
        dd_api_key = credentials('dd_api_key')
    }

    stages {
        
        stage('Docket build') {
            steps {
                sh '''
                sudo docker build -t ${ECR_REPO_NAME} .
                sudo docker tag ${ECR_REPO_NAME}:latest ${aws_account_id}.dkr.ecr.${region}.amazonaws.com/${ECR_REPO_NAME}:latest
                '''
            }
        }

    
        stage('Docker Image Push : ECR '){
            steps{
                sh """
                   sudo aws ecr get-login-password --region ${region} | sudo docker login --username AWS --password-stdin ${aws_account_id}.dkr.ecr.${region}.amazonaws.com
                   sudo docker push ${aws_account_id}.dkr.ecr.${region}.amazonaws.com/${ECR_REPO_NAME}:latest
                  """
               }
        }   

        stage('Connect to EKS '){
            steps{
                sh """
                aws configure set region "${region}"
                aws eks --region ${region} update-kubeconfig --name ${cluster}
                """
            }
        } 

        stage('install Datadog agent '){
            steps{
                sh """
                helm repo add datadog https://helm.datadoghq.com
                helm repo update
                helm install datadog-agent   -f custom-value.yaml   --set datadog.apiKey=${dd_api_key} --set datadog.site=us5.datadoghq.com  datadog/datadog
                """
            }
        } 

        stage('Deploy custome image on EKS Cluster'){
            steps{
                    sh """
                     kubectl apply -f kubernetes-menifest-files.yaml
                    """
                  }
                
            
        }
    }

    post { 
        always { 
            cleanWs()
        }
    }
}