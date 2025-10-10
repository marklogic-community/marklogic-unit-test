@Library('shared-libraries') _

def setupDockerMarkLogic(String image){
  cleanupDocker()
  sh label:'mlsetup', script: '''#!/bin/bash
  echo "Removing any running MarkLogic server and clean up MarkLogic data directory"
    sudo /usr/local/sbin/mladmin remove
    sudo /usr/local/sbin/mladmin cleandata
    cd marklogic-unit-test
    docker compose down -v || true
    docker volume prune -f
    echo "Using image: "'''+image+'''
    docker pull '''+image+'''
    MARKLOGIC_IMAGE='''+image+''' MARKLOGIC_LOGS_VOLUME=marklogicLogs docker compose up -d --build
    echo "Waiting for MarkLogic server to initialize."
    sleep 30s
  '''
}

pipeline{
  agent {label 'devExpLinuxPool'}
  options {
    checkoutToSubdirectory 'marklogic-unit-test'
    buildDiscarder logRotator(artifactDaysToKeepStr: '7', artifactNumToKeepStr: '', daysToKeepStr: '30', numToKeepStr: '')
  }
  environment{
    JAVA_HOME_DIR="/home/builder/java/jdk-17.0.2"
    GRADLE_DIR   =".gradle"
    DMC_USER     = credentials('MLBUILD_USER')
    DMC_PASSWORD = credentials('MLBUILD_PASSWORD')
  }
  stages{
    stage('tests'){
      steps{
        setupDockerMarkLogic("ml-docker-db-dev-tierpoint.bed-artifactory.bedford.progress.com/marklogic/marklogic-server-ubi:latest-12")
        sh label:'test', script: '''#!/bin/bash
          export JAVA_HOME=$JAVA_HOME_DIR
          export GRADLE_USER_HOME=$WORKSPACE/$GRADLE_DIR
          export PATH=$GRADLE_USER_HOME:$JAVA_HOME/bin:$PATH
          echo "JAVA_HOME is $JAVA_HOME"
          cd marklogic-unit-test
          ./gradlew mlTestConnections
          ./gradlew mlDeploy
          echo "mlPassword=admin" > marklogic-junit5/gradle-local.properties
          ./gradlew test || true
        '''
        junit '**/build/**/*.xml'
      }
    }
    stage('publish'){
      when {
        branch 'develop'
      }
      steps{
        sh label:'publish', script: '''#!/bin/bash
          export JAVA_HOME=$JAVA_HOME_DIR
          export GRADLE_USER_HOME=$WORKSPACE/$GRADLE_DIR
          export PATH=$GRADLE_USER_HOME:$JAVA_HOME/bin:$PATH
          cp ~/.gradle/gradle.properties $GRADLE_USER_HOME;
          cd marklogic-unit-test
           ./gradlew publish
        '''
      }
    }
  }
}
