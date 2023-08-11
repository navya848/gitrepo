pipeline {
    agent any

    tools {
        maven "M3"
    }

    stages {
        stage('SCM Checkout') {
            steps {
                // Get some code from a GitHub repository
                git branch:'main', url:'https://github.com/navya848/gitrepo.git'
                //git branch: 'main', credentialsId: 'GithubAuthToken', url: 'https://github.com/jenkins-docs/simple-java-maven-app.git'
            }
        }
        stage('Build') {
            steps {
                // Run Maven on a Unix agent.
                sh 'mvn -Dmaven.test.failure.ignore=true clean package'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                // If Maven was able to run the tests, even if some of the test
                // failed, record the test results and archive the jar file.
                success {
                    junit '**/target/surefire-reports/TEST-*.xml'
                    archiveArtifacts 'target/*.jar'
                }
            }
        }
        //stage('SonarQube Analysis') {
            /*environment {
                SCANNER_HOME = tool 'SonarQubeScanner4'
            }*/
            /*steps {
                withSonarQubeEnv(installationName: 'SonarQubeServer', credentialsId: 'Sonarqube-my-app-token') {
                
                    sh '''mvn clean verify sonar:sonar \
                        -Dsonar.projectKey=com.mycompany.app:my-app \
                        -Dsonar.host.url=http://18.191.190.150:8080/ \
                        -Dsonar.login=ac0b719808027708afc01e3e74b2ac7e3f20ba34
                    '''
                    
                    // -Dproject.settings=sonar-project.properties
                }
            }
        }
        stage("Quality Gate") {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }*/
        stage('Deliver') {
            steps {
               // sh './jenkins/scripts/deliver.sh'
               sh 'set +x'
               sh 'java -jar target/my-app-1.0-SNAPSHOT.jar'
            }
        }
        stage('Docker Build & Tag') {
            steps {
                sh 'docker --version'
      	        sh 'docker build -t navyadockerhub/my-app-helloworld:v$BUILD_NUMBER .'
                sh 'docker image tag navyadockerhub/my-app-helloworld:v$BUILD_NUMBER navyadockerhub/my-app-helloworld:latest'
            }
        }
        stage('Pushing Image to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'DockerHubCredentials', passwordVariable: 'DockerhubPassword', usernameVariable: 'DockerhubUsername')]) {
                    sh 'docker login -u ${DockerhubUsername} -p ${DockerhubPassword}'
                    sh 'docker push navyadockerhub/my-app-helloworld:v$BUILD_NUMBER'
                    sh 'docker push navyadockerhub/my-app-helloworld:latest'
                }
            }
        }
        stage('Run Docker container on Jenkins') {
            steps {
                sh 'docker run navyadockerhub/my-app-helloworld:latest'
            }
        }
    }
    post {
        always {
            sh 'docker logout'
        }
    }
}
