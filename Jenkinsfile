
def withNetwork(Closure inner) {
    networkId = UUID.randomUUID().toString()
    bat "docker network create ${networkId}"
    inner.call(networkId)
    bat "docker network rm ${networkId}"

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
        stage("Check") {
        	agent any
        		steps {
        				script {
        					def app = docker.image("8878t/project:latest")
        					def client = docker.image("curlimages/curl")

        					withNetwork{ n ->
        						app.withRun("--name myapp --network ${n}") { c ->
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
		 stage("Push to Docker Hub") {
            steps {
              echo 'push stage'
              bat "docker push 8878t/project:latest"
            }
         }
	}

	post {
		always {
			bat 'docker logout'
		}
	}
}


