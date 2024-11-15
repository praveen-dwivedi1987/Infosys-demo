pipeline {
    agent {label 'terraform-agent'}

    

    environment {
        aws_account_id = '471112682780'
        region    = 'us-east-1'
        ECR_REPO_NAME = 'infosysdemo/custome-nginx'
        cluster = 'my-cluster'
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
                   aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${aws_account_id}.dkr.ecr.${region}.amazonaws.com
                   sudo docker push ${aws_account_id}.dkr.ecr.${region}.amazonaws.com/${ECR_REPO_NAMEe}:latest
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

        stage('Deployment on EKS Cluster'){
            steps{
                    sh """
                     kubectl apply -f .
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