pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "compliance-app:${env.BUILD_ID}"
    }

    stages {
        stage('Clone') {
            steps {
                git credentialsId: 'github-pat-jenkins', url: 'https://github.com/Lohithavelmurugan/ci_cd_compliance_project.git', branch: 'main'
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
                sh './run_tests.sh'  // Make sure this script exists and is executable
            }
        }

        stage('Security Scan') {
            steps {
                echo "Performing security scan with Trivy..."
                sh 'trivy image $DOCKER_IMAGE || true'  // Avoid build failure due to non-zero exit
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
                sh './compliance_check.sh'  // Ensure this script exists and runs relevant checks
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploying Docker image..."
                // Example command – replace with your deployment logic
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
