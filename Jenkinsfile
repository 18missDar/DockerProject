pipeline{
	agent any
	environment {
	    VERSION = '1.1.0'
	    SERVER_CREDENTIALS = credentials('server-credentials')
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
				echo "login with ${SERVER_CREDENTIALS}"
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


