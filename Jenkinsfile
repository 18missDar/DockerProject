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
				bat 'docker build -t $DOCKERHUB_CREDENTIALS_USR/hello_world:latest .'
			}
		}

		stage("Check") {
			agent any
			steps {
				script {
					def app = docker.image("$DOCKERHUB_CREDENTIALS_USR/hello_world")
					def client = docker.image("curlimages/curl")

					withDockerNetwork{ n ->
						app.withRun("--name app --network ${n}") { c ->
							client.inside("--network ${n}") {
                echo "I'm client!"
                bat "sleep 60"
								bat "curl -S --fail http://app:8080 > curl_output.txt"
                sh "cat curl_output.txt"
                archiveArtifacts artifacts: 'curl_output.txt'
							}
						}
          }
				}
			}
    }

		stage('Login') {
			steps {
				bat 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
			}
		}



		stage('Push') {
			steps {
				bat 'docker push $DOCKERHUB_CREDENTIALS_USR/hello_world:latest'
			}
		}
	}

	post {
		always {
			bat 'docker logout'
		}
	}
}