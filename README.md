# Terraform

Each deployment contains a very generic configuration of main.tf, outputs.tf and variables.tf.

main.tf: This file contains the core configurations for the deployment, here the terraform version and all the resources to be deployed are explicitly defined.\
outputs.tf: This file contains the defined outputs of the configuration in the main terraform file.\
variables.tf: This file contains the variables that would be used in our configuration, such variables include the name of the server, the name of the S3 bucket, the server port, and information that we would not want to hardcode into our configuration.
