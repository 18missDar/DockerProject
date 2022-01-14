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
// 	получпаем реквизиты для входа
		DOCKERHUB_CREDENTIALS=credentials('dockerhub')
	}
	stages {
		stage('Build') {
			steps {
				sh 'docker build -t $DOCKERHUB_CREDENTIALS_USR/dockerhub:123456 .'
			}
		}

		stage("Check") {
			agent any
			steps {
				script {
					def app = docker.image("$DOCKERHUB_CREDENTIALS_USR/dockerhub")
					def client = docker.image("curlimages/curl")

					withDockerNetwork{ n ->
						app.withRun("--name app --network ${n}") { c ->
							client.inside("--network ${n}") {
                echo "I'm client!"
                bat "sleep 60"
								bat "curl -S --fail http://app:8080 > curl_output.txt"
                bat "cat curl_output.txt"
                archiveArtifacts artifacts: 'curl_output.txt'
							}
						}
          }
				}
			}
    }

		stage('Login') {
			steps {
				bat 'echo $DOCKERHUB_CREDENTIALS_PSW | dockerhub login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
			}
		}



		stage('Push') {
			steps {
				bat 'docker push $DOCKERHUB_CREDENTIALS_USR/dockerhub:123456'
			}
		}
	}

	post {
		always {
			bat 'docker logout'
		}
	}
}