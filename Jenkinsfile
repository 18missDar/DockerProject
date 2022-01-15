def nameNetwork(String prefix) {
    return prefix + "-" + UUID.randomUUID().toString()
}

pipeline{
	agent any
	environment {
	    VERSION = 'latest'
	    SERVER_CREDENTIALS = credentials('server-credentials')
	    USER = 'dockerhub'
        REP = 'petclinic'
        ART_ID = 'spring-petclinic'
	}
	stages {
		stage('Build') {
			steps {
				echo "build stage with version ${VERSION}"
				script
                {
                  docker.build("${USER}/${REP}:${VERSION}", "--build-arg JAR_VERSION=${VERSION} --build-arg JAR_ARTIFACT_ID=${ART_ID} -f Dockerfile .")
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
              echo 'push stage'
              bat "docker push iis"
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


