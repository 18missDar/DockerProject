
pipeline{
	agent any

	stages {
		stage('Build') {
			steps {
				echo 'build...'
			}
		}
		stage('test') {
			steps {
				echo 'test..'
			}
		}
		stage('deploy') {
			steps {
				echo 'deploy...'
			}
		}
	}

	post {
		always {
			bat 'docker logout'
		}
	}
}