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
                docker build -t ${ECR_REPO_NAME} .
                docker tag ${ECR_REPO_NAME}:latest ${aws_account_id}.dkr.ecr.${region}.amazonaws.com/${params.ECR_REPO_NAME}:latest
                '''
            }
        }

    
        stage('Docker Image Push : ECR '){
         
            steps{
               script{
                   
                    sh """
                   aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${aws_account_id}.dkr.ecr.${region}.amazonaws.com
                   docker push ${aws_account_id}.dkr.ecr.${region}.amazonaws.com/${ECR_REPO_NAMEe}:latest
                  """
               }
            }
        }   

        stage('Connect to EKS '){
            when { expression {  params.action == 'create' } }
        steps{

            script{

                sh """
                aws configure set region "${params.Region}"
                aws eks --region ${params.Region} update-kubeconfig --name ${params.cluster}
                """
            }
        }
        } 

        stage('Deployment on EKS Cluster'){
            steps{
                script{
                  
                  def apply = false

                  try{
                    input message: 'please confirm to deploy on eks', ok: 'Ready to apply the config ?'
                    apply = true
                  }catch(err){
                    apply= false
                    currentBuild.result  = 'UNSTABLE'
                  }
                  if(apply){

                    sh """
                      kubectl apply -f .
                    """
                  }
                }
            }
        }
    }

    post { 
        always { 
            cleanWs()
        }
    }
}