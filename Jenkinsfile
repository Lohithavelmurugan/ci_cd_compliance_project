pipeline {
  agent any

  stages {
    stage('Clone') {
      steps {
        git branch: 'main', credentialsId: 'github-pat-jenkins', url: 'https://github.com/Lohithavelmurugan/ci_cd_compliance_project.git'
      }
    }

    stage('Build') {
      steps {
        sh 'docker build -t myapp .'
      }
    }

    stage('Unit Tests') {
      steps {
        sh 'pytest test_app.py'
      }
    }

    stage('Security Scan') {
      steps {
        sh 'trivy image myapp || true'
      }
    }

    stage('Secrets Check') {
      steps {
        sh 'gitleaks detect --source . --no-git -v || true'
      }
    }

    stage('Institutional Compliance') {
      steps {
        sh 'chmod +x compliance_rules.sh'
        sh './compliance_rules.sh'
      }
    }

    stage('Deploy') {
      steps {
        echo "Ready to deploy! 🚀"
      }
    }
  }
}
