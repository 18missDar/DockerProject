def nameNetwork(String prefix) {
    return prefix + "-" + UUID.randomUUID().toString()
}

pipeline{
	agent any
	environment {
	    VERSION = 'latest'
	    SERVER_CREDENTIALS = credentials('server-credentials')
	    NET_PET = UUID.randomUUID().toString()
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


