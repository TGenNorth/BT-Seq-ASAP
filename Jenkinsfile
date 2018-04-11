// https://github.com/jenkinsci/pipeline-model-definition-plugin/wiki/Syntax-Reference
pipeline {
  agent none
    
  options {
    buildDiscarder(logRotator(numToKeepStr:'50'))
    //skipDefaultCheckout()
  }
    
  stages {
    stage('Install') {
      agent { docker { image 'python:3.6.4' } }
      steps {
        sh '''
          python -m venv env
          . env/bin/activate
          pip --no-cache-dir install numpy
          pip --no-cache-dir install .
'''.stripIndent()
      }
    }
  }
}
