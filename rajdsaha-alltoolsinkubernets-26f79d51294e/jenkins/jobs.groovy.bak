def gitUrl = 'https://bitbucket.org/rajdsaha/spring-petclininctest.git'
def BUILD_NUMBER = '$BUILD_NUMBER'
job('Build-Petclinic') {
    scm {
        git {
          remote {
            url(gitUrl)
            credentials('9b050393-41d3-4129-8096-00a4b17c2868')
          }
        }
      }
    steps {
        maven{
          goals('clean package')
          mavenInstallation('maven')
    }
        shell("""\
            |whoami
            |docker build -t cicdpipeline/petclinictest:\$BUILD_NUMBER .
            |docker login --username cicdpipeline --password entersys1
            |docker push cicdpipeline/petclinictest:\$BUILD_NUMBER
            |docker rmi cicdpipeline/petclinictest:\$BUILD_NUMBER
            |""".stripMargin())
}
   publishers {
      downstreamParameterized {
          trigger('Deploy-To-Kubernates-Cluster') {
            condition('UNSTABLE_OR_BETTER')
            parameters {
              predefinedProps([
                "TAG"    : "\${BUILD_NUMBER}",
              ])
            }
          }
        }
      }
}

job('Deploy-To-Kubernates-Cluster'){
     parameters {
        stringParam("TAG", "", "It takes build number from upstream job")
     }
     scm {
        git {
          remote {
            url('https://rajdsaha@bitbucket.org/rajdsaha/kubernates.git')
            credentials('9b050393-41d3-4129-8096-00a4b17c2868')
          }
        }
      }
     steps{
        kubernetesDeploy {
            context {
                configs('*.yaml')
                kubeconfigId('container')
                enableConfigSubstitution(true)
            }
        
        }
   }
}
