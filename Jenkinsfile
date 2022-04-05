pipeline{
    agent any
    
    stages {
        stage("Checkout") {
            steps {
                git branch: 'master', url: 'https://bitbucket.org/chicho2020/devops-challenge.git'
            }
        }

        stage("Acceptance test") {
            steps {
                sleep 60
                sh "npm test"
            }
        }

        stage("Docker build") {
            steps {
                sh "docker build -t thinksec/dockerize-node ."
            }
        }
    }
}