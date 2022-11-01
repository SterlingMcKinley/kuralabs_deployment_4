pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh '''#!/bin/bash
                python3 -m venv test3
                source test3/bin/activate
                pip install pip --upgrade
                pip install -r requirements.txt
                export FLASK_APP=application
                flask run &
                '''
            }
        }
        stage('Test 1') {
            steps {
                sh '''#!/bin/bash
                date
                whoami
                echo "HEY COW, NAME WHAT THING YOU LEARNED IN DEPLOYMENT #2...."
                echo "I LEARNED GROOOOOOOVY LOL"
                '''
            }
        }
        stage('Test 2') {
            steps {
                sh '''#!/bin/bash
                echo "This is a 2nd test script"
                echo "Date : `date`"
                echo "Hostname : `hostname`"
                '''
            }
        }
        stage('test') {
            steps {
                sh '''#!/bin/bash
                source test3/bin/activate
                py.test --verbose --junit-xml test-reports/results.xml
                '''
            }

            post {
                always {
                    junit 'test-reports/results.xml'
                }
            }
        }

        stage('Init') {
            steps {
                withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'),
                string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                    dir('terraform_deployment4') {
                        sh 'terraform init'
                    }
                }
            }
        }
        stage('Plan') {
            steps {
                withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'),
                string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                    dir('terraform_deployment4') {
                        sh 'terraform plan -out plan.tfplan -var="aws_access_key=$aws_access_key" -var="aws_secret_key=$aws_secret_key"'
                    }
                }
            }
        }
        stage('Apply') {
            steps {
                withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'),
                string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                    dir('terraform_deployment4') {
                        sh 'terraform apply plan.tfplan'
                    }
                }
            }
        }

        stage('Destroy') {
            steps {
                withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'),
                string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                    dir('dp4_terraform/aws_infra') {
                        sh 'terraform destroy --auto-approve -var="aws_access_key=$aws_access_key" -var="aws_secret_key=$aws_secret_key"'
                    }
                }
            }
        }
    }
    post {
        always {
            emailext to: "mckinleyvsterling@gmail.com",
            subject: "Jenkins Alert for ${currentBuild.projectName} - Build ${currentBuild.number} Result",
            body: "Confirming that build ${currentBuild.number} has been completed for ${currentBuild.projectName} with a result of ${currentBuild.result}.\n\nFor more information, please visit ${env.BUILD_URL} for details on the build."
        }
    }
}
