def nameNetwork(String prefix) {
    return prefix + "-" + UUID.randomUUID().toString()
}

pipeline{
	agent any
	environment {
	    VERSION = '1.1.0'
	    SERVER_CREDENTIALS = credentials('server-credentials')
	    imagename = "18missDar/DockerProject"
        registryCredential = 'dockerhub'
        dockerImage = ''
	}
	stages {
		stage('Build') {
			steps {
				echo "build stage with version ${VERSION}"
				script {
                    dockerImage = docker.build imagename
                }
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
               script {
                    docker.withRegistry( '', registryCredential)
                    dockerImage.push("$BUILD_NUMBER")
                    dockerImage.push('latest')

               }
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


