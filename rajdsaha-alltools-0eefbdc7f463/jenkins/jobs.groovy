def gitUrl = 'https://bitbucket.org/rajdsaha/spring-petclininctest.git'
def BUILD_NUMBE = '$BUILD_NUMBER'
def IP = '$(wget -q -O - http://169.254.169.254/latest/meta-data/local-ipv4)'
job('Build-Petclinic') {
    scm {
        git {
          remote {
            url(gitUrl)
            credentials('9b050393-41d3-4129-8096-00a4b17c2868')
          }
        }
      }

    triggers {
        bitbucketPush()
    }
    steps {
        maven{
          goals('clean package')
          mavenInstallation('maven')
    }
        shell("""\
            |whoami
            |docker build -t \$(wget -q -O - http://169.254.169.254/latest/meta-data/local-ipv4):8088/petclinictest:\$BUILD_NUMBER .
            |docker login --username admin --password password \$(wget -q -O - http://169.254.169.254/latest/meta-data/local-ipv4):8088
            |docker push \$(wget -q -O - http://169.254.169.254/latest/meta-data/local-ipv4):8088/petclinictest:\$BUILD_NUMBER
            |docker push \$(wget -q -O - http://169.254.169.254/latest/meta-data/local-ipv4):8088/petclinictest:\$BUILD_NUMBER
            |""".stripMargin())
}
   publishers {
      downstreamParameterized {
          trigger('Deploy') {
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

job('Deploy'){
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
        shell("""\
            |#!/bin/bash
			|chmod 755 deploy.sh
			|./deploy.sh
            |""".stripMargin())

   }
}
