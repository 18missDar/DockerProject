pipeline {

  agent any

  parameters {
    string(name: 'server', defaultValue: "C:\\ProgramData\\Jenkins\\.jenkins\\workspace\\NewProject_main")
    string(name: 'emailTo', defaultValue: "miss.dar18@mail.ru")
  }

  triggers {
    pollSCM('* * * * *')
  }

  tools {
    maven 'jenkinsMaven'
  }

  stages {
    stage('Build') {
      steps {
          bat """
            cd freddie-app
            mvn clean package
          """
        }
    }
    stage('Deploy to Staging') {
      steps {
        echo 'Deploy to staging environment'

        // Launch tomcat
        bat """
          cd ${params.server}qa\\bin
          startup
        """
        bat """
          cd ${params.server}staging\\bin
          startup
        """

      }
      post {
        success {
          emailNotification('Successfully Deployed to Staging')
        }
        failure {
          emailNotification('FAILED to deploy to staging')
        }
      }
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