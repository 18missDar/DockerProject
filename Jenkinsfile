pipeline{
	agent any
	environment {
	    VERSION = '1.1.0'
	}
	stages {
		stage('Build') {
			steps {
				echo "build stage with version ${VERSION}"
			}
		}

		stage('Login') {
			steps {
				echo 'login stage'
				withCredentials([
				usernamePassword(credentials: 'server-credentials', usernameVariable: USER, passwordVariable: PWD)
				]){
				echo "login with ${USR} and ${PWD}"
				}
			}
		}
		stage('Push') {
			steps {
				echo 'push stage'
				bat 'docker image push --all-tags localhost:8080/'
			}
		}
	}

	post {
		always {
			bat 'docker logout'
		}
	}
}


