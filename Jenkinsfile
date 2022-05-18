pipeline {
    agent any

    stages {
        stage("Git Checkout") {
            steps {
                script {
                    println("change directory")
                       sh("""
                        cd /root/infra
                        """)

                }
                // Source Checkout
                checkout scm
            }
        }

        /*********************** 1. "Infra init *************************/
        stage("Infra init") {
            steps {
                script {
                    println("terraform init")
                       sh("""
                        terraform init
                        """)

                }
            }
        }
        /*************************************************************/
        /*********************** 2. "Infra Plan *************************/
        stage("Infra Plan") {
            steps {
                script {
                    println("terraform plan")
                    //    sh("""
                    //     terraform plan
                    //     """)

                }
            }
        }
        /*************************************************************/
        /*********************** 3. "Infra Apply *************************/
         stage("Infra Apply") {
             when {
                expression {env.GIT_BRANCH == 'origin/main'}
            }

             steps {
                 script {
                     println("terraform apply")
                        // sh("""
                        //  terraform apply  -auto-approve -no-color
                        //  """)

                 }
             }
         }
        /*************************************************************/


    }

}

