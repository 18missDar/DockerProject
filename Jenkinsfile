
def nameNetwork(String prefix) {
    return prefix + "-" + UUID.randomUUID().toString()
}

def petclinicNetwork
def curlNetwork

def nameContainer(String prefix) {
    return prefix + "-cont-" + UUID.randomUUID().toString()
}

def petclinicContainer
def curlContainer

def checkCurlOutput(String curlOutput) {
    return curlOutput.contains('<title>PetClinic :: a Spring Framework demonstration</title>')
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
        stage("Check") {
        steps {
            script {
                petclinicContainer = nameContainer('petclinic')
                curlContainer = nameContainer('curl')
                bat ("docker run --name ${petclinicContainer} --network ${petclinicNetwork} -p 9000:9000 8878t/project:latest &")
                def petclinicContainerRunning = bat(script: "docker container inspect -f '{{.State.Running}}' ${petclinicContainer}", returnStdout: true).trim()
                  while (!petclinicContainerRunning.equals("true")) {
                     println("Waiting for Spring Pet Clinic container readiness...")
                       sleep(5)
                      petclinicContainerRunning = bat(script: "docker container inspect -f '{{.State.Running}}' ${petclinicContainer}", returnStdout: true).trim()
                  }
                def petclinicAppRunningCheck = "Tomcat started on port"
                def petclinicAppRunning = bat(script: "docker container logs ${petclinicContainer}", returnStdout: true)
                  while (null == petclinicAppRunning || !petclinicAppRunning.contains(petclinicAppRunningCheck)) {
                  println("Waiting for Spring Pet Clinic app readiness...")
                  sleep(5)
                  petclinicAppRunning = bat(script: "docker container logs ${petclinicContainer}", returnStdout: true)
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
		success {
             echo 'Thank you for work. SUCCESS'
        }
        failure {
             echo 'Try again'
        }
	}
}


