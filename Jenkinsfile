pipeline {
  agent {
    dockerfile {
      additionalBuildArgs '--build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g)'
    }
  }
  stages {
    stage("Init title") {
      when { changeRequest() }
      steps {
        script {
          currentBuild.displayName = "PR ${env.CHANGE_ID}: ${env.CHANGE_TITLE}"
        }
      }
    }
    stage('Build') {
      steps {
        ansiColor('xterm') {
          sh '''
            make deps -B
            make build-java
          '''
        }
      }
    }
    stage('Test Execution') {
      steps {
        ansiColor('xterm') {
          sh '''
            export PATH=$HOME/.local/bin:$PATH
            nprocs=6
            make test-execution -j"$nprocs"
          '''
        }
      }
    }
    //stage('Test Proof') {
    //  steps {
    //    ansiColor('xterm') {
    //      sh '''
    //        export PATH=$HOME/.local/bin:$PATH
    //        nprocs=6
    //        make test-proof -j"$nprocs"
    //      '''
    //    }
    //  }
    //}
  }
}
