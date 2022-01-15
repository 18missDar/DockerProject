def nameNetwork(String prefix) {
    return prefix + "-" + UUID.randomUUID().toString()
}

pipeline{
	agent any
	environment {
	    VERSION = '1.1.0'
	    SERVER_CREDENTIALS = credentials('server-credentials')
	}
	stages {
		stage('Build') {
			steps {
				echo "build stage with version ${VERSION}"
				bat "docker build -t iis ."
			}
		}

		stage('Login to Docker') {
			steps {
				echo 'login stage'
				echo "login with ${SERVER_CREDENTIALS}"
			}
		}
		 stage("Push to Docker Hub") {
            steps {
              echo 'push stage'
            }
         }
		stage("Create networks") {
             steps {
                script {
                   petclinicNetwork = nameNetwork('petclinic')
                   curlNetwork = nameNetwork('curl')
             }
             bat "docker network create ${petclinicNetwork}"
             bat "docker network create ${curlNetwork}"
           }
        }
	}

	post {
		always {
			bat 'docker logout'
		}
	}
}


