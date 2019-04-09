def gitUrl = 'https://bitbucket.org/sharnal/alltools.git'
def BUILD_NUMBE = '$BUILD_NUMBER'
def IP = '$(wget -q -O - http://169.254.169.254/latest/meta-data/local-ipv4)'
job('Build-Petclinic') {
    scm {
        git {
          remote {
            url('https://bitbucket.org/sharnal/spring-petclininctest.git')
            credentials('BitbucketCred')
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
            |docker build -t \$nodedns:8088/petclinictest:\$BUILD_NUMBER .
            |docker login --username admin --password password \$nodedns:8088
            |docker build -t \$nodedns:8088/petclinictest:latest .
            |docker push \$nodedns:8088/petclinictest:\$BUILD_NUMBER
            |docker push \$nodedns:8088/petclinictest:latest
            |""".stripMargin())
}
   publishers {
      downstreamParameterized {
          trigger('Deploy') {
            condition('UNSTABLE_OR_BETTER')
            parameters {
              predefinedProps([
                "registry"    : "\${nodedns}:8088",
              ])
            }
          }
        }
      }
}

job('Deploy'){
     parameters {
        stringParam("registry", "", "It takes registry for docker login")
     }
     scm {
        git {
          remote {
            url(gitUrl)
            credentials('BitbucketCred')
          }
        }
      }
     steps{
        shell("""\
            |#!/bin/bash
			|chmod +x petclinic/deploy.sh
			|petclinic/deploy.sh
            |""".stripMargin())

   }
}
