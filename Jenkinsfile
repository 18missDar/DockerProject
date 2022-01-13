def withDockerNetwork(Closure inner) {
  try {
    networkId = UUID.randomUUID().toString()
    sh "docker network create ${networkId}"
    inner.call(networkId)
  } finally {
    sh "docker network rm ${networkId}"
  }
}

pipeline{
	agent any
	environment {
// 	получпаем реквизиты для входа
        JAR_VERSION = sh (returnStdout: true, script: 'mvn help:evaluate -Dexpression=project.version -q -DforceStdout').trim()
        JAR_ARTIFACT_ID = sh (returnStdout: true, script: 'mvn help:evaluate -Dexpression=project.artifactId -q -DforceStdout').trim()
        DOCKER_HUB_VERSION = JAR_VERSION.replace("-SNAPSHOT", "-snapshot")
		DOCKERHUB_CREDENTIALS=credentials('dockerhub')
	}
	stages {
		stage("Build") {
            steps {
                script {
                   docker.build("--build-arg JAR_VERSION=${JAR_VERSION} --build-arg JAR_ARTIFACT_ID=${JAR_ARTIFACT_ID} -f Dockerfile .")
                }
           }
        }

	}

	post {
       always {
          sh "docker-compose down || true"
       }

       success {
          bitbucketStatusNotify buildState: "SUCCESSFUL"
       }

       failure {
          bitbucketStatusNotify buildState: "FAILED"
       }
    }
}