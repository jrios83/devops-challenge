pipeline{
    agent any
    
    stages {
        stage("Checkout") {
            steps {
                git branch: 'main', url: 'https://github.com/jrios83/devops-challenge.git'
            }
        }

        stage("Docker build") {
            steps {
                sh "docker build -t thinksec/dockerize-node ."
            }
        }
    }
}