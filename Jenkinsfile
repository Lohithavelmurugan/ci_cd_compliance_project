pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "compliance-app:${env.BUILD_ID}"
    }

    stages {
        stage('Clone') {
            steps {
                script {
                    // Clean the workspace before cloning
                    cleanWs()
                    // Explicitly clone the repository and check if it was successful
                    echo "Cloning repository..."
                    sh 'git clone https://github.com/Lohithavelmurugan/ci_cd_compliance_project.git'
                    // Navigate into the repository directory
                    dir('ci_cd_compliance_project') {
                        echo "Checked out to main branch"
                        sh 'git checkout main'
                    }
                }
            }
        }

        stage('Build') {
            steps {
                echo "Building Docker image..."
                dir('ci_cd_compliance_project') {  // Ensure Docker build is run inside the cloned repo
                    sh 'docker build -t $DOCKER_IMAGE .'
                }
            }
        }

        stage('Unit Tests') {
            steps {
                echo "Running unit tests..."
                dir('ci_cd_compliance_project') {  // Ensure unit tests are run inside the cloned repo
                    sh './run_tests.sh'
                }
            }
        }

        stage('Security Scan') {
            steps {
                echo "Performing security scan with Trivy..."
                dir('ci_cd_compliance_project') {  // Ensure security scan is run inside the cloned repo
                    sh 'trivy image $DOCKER_IMAGE || true'
                }
            }
        }

        stage('Secrets Check') {
            steps {
                echo "Scanning for hardcoded secrets..."
                dir('ci_cd_compliance_project') {  // Ensure secrets check is run inside the cloned repo
                    sh 'gitleaks detect --source=. || true'
                }
            }
        }

        stage('Institutional Compliance') {
            steps {
                echo "Running institutional compliance checks..."
                dir('ci_cd_compliance_project') {  // Ensure compliance check is run inside the cloned repo
                    sh './compliance_check.sh'
                }
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
