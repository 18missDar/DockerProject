def withDockerNetwork(Closure inner) {
  try {
    networkId = UUID.randomUUID().toString()
    sh "docker network create ${networkId}"
    inner.call(networkId)
  } finally {
    sh "docker network rm ${networkId}"
  }
}

pipeline{
	agent any
	environment {
// 	получпаем реквизиты для входа
		DOCKERHUB_CREDENTIALS=credentials('dockerhub')
	}
	stages {
		stage('Build') {
			steps {
				sh 'docker build -t $DOCKERHUB_CREDENTIALS_USR/hello_world:latest .'
			}
		}

		stage('Login') {
			steps {
				sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
			}
		}

	}

	post {
		always {
			sh 'docker logout'
		}
	}
}