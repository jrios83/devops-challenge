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

        stage("Deploy to staging") {
            steps {
                sh "docker run -p 49160:3000 -d thinksec/dockerize-node"
            }
        }

    }
}