def withDockerNetwork(Closure inner) {
  try {
    networkId = UUID.randomUUID().toString()
    bat "docker network create ${networkId}"
    inner.call(networkId)
  } finally {
    bat "docker network rm ${networkId}"
  }
}

pipeline{
	agent any
	environment {
	    DOCKER_HUB_VERSION = "2.9.1"
        DOCKER_HUB_USER = 'hello_world'
        DOCKER_HUB_REPOSITORY = 'spring-petclinic'
		DOCKERHUB_CREDENTIALS=credentials('dockerhub')
	}
	stages {
		stage('Build') {
        	steps {
        		bat 'docker build -t $DOCKERHUB_CREDENTIALS_USR/hello_world:latest .'
        	}
        }

	  stage("Login to Docker Hub") {
         steps {
            withCredentials([
                usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_HUB_USER', passwordVariable: 'DOCKER_HUB_PASSWORD')
                      ]) {
                bat 'echo ${DOCKER_HUB_PASSWORD} | docker login -u ${DOCKER_HUB_USER} --password-stdin'
             }
        }
    }
		stage("Push to Docker Hub") {
             steps {
               bat 'docker push ${DOCKER_HUB_USER}/${DOCKER_HUB_REPOSITORY}:${DOCKER_HUB_VERSION}'
           }
        }
	}

	post {
		always {
			bat 'docker logout'
		}
	}
}