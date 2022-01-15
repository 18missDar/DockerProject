def nameNetwork(String prefix) {
    return prefix + "-" + UUID.randomUUID().toString()
}

pipeline{
	agent any
	environment {
	    VERSION = 'latest'
	    SERVER_CREDENTIALS = credentials('server-credentials')
	}
	stages {
		stage('Build') {
			steps {
				echo "build stage with version ${VERSION}"
				bat "docker build -t 8878t/project:latest ."
			}
		}

		stage('Login') {
        	steps {
        		bat 'echo 123456789| docker login -u 8878t --password-stdin'
        	}
        }
		 stage("Push to Docker Hub") {
            steps {
              echo 'push stage'
              bat "docker push 8878t/project:latest"
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


