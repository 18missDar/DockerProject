
pipeline{
	agent any
    environment {
		JAR_VERSION = bat (returnStdout: true, script: 'mvn help:evaluate -Dexpression=project.version -q -DforceStdout').trim()
        JAR_ARTIFACT_ID = bat (returnStdout: true, script: 'mvn help:evaluate -Dexpression=project.artifactId -q -DforceStdout').trim()
        DOCKER_HUB_VERSION = JAR_VERSION.replace("-SNAPSHOT", "-snapshot")
        DOCKER_HUB_USER = 'dockerhub'
        DOCKER_HUB_REPOSITORY = 'spring-petclinic'
	}
	stages {

		stage("Build") {
            steps {
                script {
                   docker.build("${DOCKER_HUB_USER}/${DOCKER_HUB_REPOSITORY}:${DOCKER_HUB_VERSION}", "--build-arg JAR_VERSION=${JAR_VERSION} --build-arg JAR_ARTIFACT_ID=${JAR_ARTIFACT_ID} -f Dockerfile .")
               }
           }
       }
       stage("Login to Docker Hub") {
          steps {
            withCredentials([
                   usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_HUB_USER', passwordVariable: 'DOCKER_HUB_PASSWORD')
                   ]) {
                   bat 'echo ${DOCKER_HUB_PASSWORD} | docker login -u ${DOCKER_HUB_USER} --password-stdin'
               }
           }
       }
		stage('test') {
			steps {
				echo 'test stage'
			}
		}
		stage('deploy') {
			steps {
				echo 'deploy stage'
			}
		}
	}

	post {
		always {
			bat 'docker logout'
		}
	}
}