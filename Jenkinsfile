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
	stages {
		stage('Build') {
			steps {
				bat 'docker build github.com/18missDar/DockerProject'
			}
		}

		stage('Push') {
			steps {
				bat 'docker image push --all-tags registry-host:5000/myname/myimage'
			}
		}
	}

	post {
		always {
			bat 'docker logout'
		}
	}
}