pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "compliance-app:${env.BUILD_ID}"
    }

    stages {
        stage('Clone') {
            steps {
                script {
                    echo "Cloning repository..."
                    checkout scm  // This uses the repository configured in the Jenkins job configuration.
                }
            }
        }

        stage('Build') {
            steps {
                echo "Building Docker image..."
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Unit Tests') {
            steps {
                echo "Running unit tests..."
                sh './run_tests.sh'
            }
        }

        stage('Security Scan') {
            steps {
                echo "Performing security scan with Trivy..."
                sh 'trivy image $DOCKER_IMAGE || true'
            }
        }

        stage('Secrets Check') {
            steps {
                echo "Scanning for hardcoded secrets..."
                sh 'gitleaks detect --source=. || true'
            }
        }

        stage('Institutional Compliance') {
            steps {
                echo "Running institutional compliance checks..."
                sh './compliance_check.sh'
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploying Docker image..."
                sh 'docker run -d --name compliance_app $DOCKER_IMAGE'
            }
        }
    }

    post {
        always {
            echo "Cleaning up Docker..."
            sh 'docker system prune -f'
        }
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed. Check the logs for errors."
        }
    }
}
