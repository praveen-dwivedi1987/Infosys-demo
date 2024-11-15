pipeline {
    agent {label 'terraform-agent'}

    stages {
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }
        stage('terraform check') {
            steps {
                sh '''terraform version'''
            }
        }

        stage ('files check'){
            steps{
                sh '''ls -lhrt'''
            }
        }


        stage('terraform init'){
            when {
                branch eks-cluster-terraform
            }
            steps{
                
                    sh '''
                    pwd
                    terraform init
                    '''
            
            }
            
        }

        

        stage('trivy secret scan'){
            when {
                branch eks-cluster-terraform
            }
            steps{
                sh '''
                 trivy fs --scanners misconfig,secret .
                 '''
                
            }

        
        }

        stage('terraform plan'){
            when {
                branch eks-cluster-terraform
            }
            steps{
                sh '''                             
                    terraform plan -out tf.plan
t                   terraform show -no-color tf.plan > tfplan.txt
                    '''
                }
        }

        stage('terraform apply'){
            when {
                branch eks-cluster-terraform
            }
            steps{
                
                    sh '''
                    terraform apply "tf.plan" -auto-approve
                    '''
            }
        }
    }


    post { 
        always { 
            cleanWs()
        }
    }
}