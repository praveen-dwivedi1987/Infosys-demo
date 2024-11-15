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


        stage('terraform blank init'){
            
            steps{
                
                    sh ''' terraform init '''
            
            }
            
        }

        stage('trivy secret scan'){
            steps{
                sh '''
                 trivy fs --scanners misconfig,secret .
                 '''
                
            }

        
        }

        stage('terraform plan'){
            steps{
                sh '''                             
                    terraform plan -out tf.plan
                    terraform show -no-color tf.plan > tfplan.txt
                    '''
            }
        }

        stage('terraform apply'){
            steps{
                
                    sh '''
                    terraform apply "tf.plan"
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
