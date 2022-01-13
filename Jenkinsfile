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

pipeline {
    agent any
    environment {
        JAR_VERSION = sh (returnStdout: true, script: 'mvn help:evaluate -Dexpression=project.version -q -DforceStdout').trim()
        JAR_ARTIFACT_ID = sh (returnStdout: true, script: 'mvn help:evaluate -Dexpression=project.artifactId -q -DforceStdout').trim()
        DOCKER_HUB_VERSION = JAR_VERSION.replace("-SNAPSHOT", "-snapshot")
    }
    stages {
        stage("Init") {
            steps {
                echo 'BE FIRE NOT TO BURN, BE FIRE TO SEND LIGHT'
            }
        }
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
                    usernamePassword(credentialsId: 'docker_hub_credentials', usernameVariable: 'DOCKER_HUB_USER', passwordVariable: 'DOCKER_HUB_PASSWORD')
                    ]) {
                    sh 'echo ${DOCKER_HUB_PASSWORD} | docker login -u ${DOCKER_HUB_USER} --password-stdin'
                }
            }
        }
        stage("Push to Docker Hub") {
            steps {
                sh 'docker push ${DOCKER_HUB_USER}/${DOCKER_HUB_REPOSITORY}:${DOCKER_HUB_VERSION}'
            }
        }
        stage("Pull from Docker Hub") {
            steps {
                sh 'docker pull ${DOCKER_HUB_USER}/${DOCKER_HUB_REPOSITORY}:${DOCKER_HUB_VERSION}'
            }
        }
        stage("Create networks") {
            steps {
                script {
                    petclinicNetwork = nameNetwork('petclinic')
                    curlNetwork = nameNetwork('curl')
                }
                sh "docker network create ${petclinicNetwork}"
                sh "docker network create ${curlNetwork}"
            }
        }
    }
    post {
        always {
            sh "docker stop ${petclinicContainer}"
        }

    }
}