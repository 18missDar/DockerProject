
pipeline{
	agent any
	environment {
		SERVER_CREDENTIALS=credentials('server-credentials')
	}
	parameters {
        string(name: 'emailTo', defaultValue: "timothyjames.short@gmail.com")
      }
	stages {
		stage('Build') {
			steps {
				echo 'build stage'
			}
		}

		stage('Login') {
			steps {
				echo 'login stage'
				withCredentials([
				usernamePassword(credentials: 'server-credentials', usernameVariable: USER, passwordVariable: PWD)
				]){
				bat 'some script ${USER} ${PWD}'
				}
			}
		}
		stage('Push') {
			steps {
				echo 'push stage'
			}
		}
	}

	post {
		always {
			bat 'docker logout'
		}
		success {
           emailNotification('Successfully Deployed to Staging')
        }
        failure {
           emailNotification('FAILED to deploy to staging')
        }
	}
}


def emailNotification(status) {
  emailext(
  to: "${params.emailTo}",
  subject: "${status}",
  body: "Job Name: <b>${env.JOB_NAME}</b> <br>" +
      "Build: <b>${env.BUILD_NUMBER}</b> <br>" +
      "<a href=${env.BUILD_URL}>Check Console Output</a>"
  )
}