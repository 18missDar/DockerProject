def nameNetwork(String prefix) {
    return prefix + "-" + UUID.randomUUID().toString()
}

pipeline{
	agent any
	environment {
	    VERSION = '1.1.0'
	    SERVER_CREDENTIALS = credentials('server-credentials')
	    DOCKER_HUB_USER = 'dockerhub'
        DOCKER_HUB_REPOSITORY = 'spring-petclinic'
	}
	stages {
		stage('Build') {
			steps {
				echo "build stage with version ${VERSION}"
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
               bat 'docker push ${DOCKER_HUB_USER}/${DOCKER_HUB_REPOSITORY}:${VERSION}'
            }
         }
         stage("Pull from Docker Hub") {
             steps {
                bat 'docker pull ${DOCKER_HUB_USER}/${DOCKER_HUB_REPOSITORY}:${VERSION}'
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


