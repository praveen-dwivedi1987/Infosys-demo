pipeline {
    agent {label 'terraform-agent'}

    parameters{

        
        string(name: 'aws_account_id', description: " AWS Account ID", defaultValue: '471112682780')
        string(name: 'Region', description: "Region of ECR", defaultValue: 'us-east-1')
        string(name: 'ECR_REPO_NAME', description: "name of the ECR", defaultValue: 'infosysdemo/custome-nginxe')
        string(name: 'cluster', description: "name of the EKS Cluster", defaultValue: 'my-cluster')
    }


    stages {
        
        stage('Docket build') {
            steps {
                sh '''
                docker build -t ${params.ECR_REPO_NAME} .
                docker tag ${params.ECR_REPO_NAME}:latest ${params.aws_account_id}.dkr.ecr.${params.region}.amazonaws.com/${params.ECR_REPO_NAME}:latest
                '''
            }
        }

    
        stage('Docker Image Push : ECR '){
         when { expression {  params.action == 'create' } }
            steps{
               script{
                   
                    dockerImagePush("${params.aws_account_id}","${params.Region}","${params.ECR_REPO_NAME}")
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