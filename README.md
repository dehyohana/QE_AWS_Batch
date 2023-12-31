This project enables you to execute electronic structure calculations utilizing the plane-wave pseudopotential (PWPP) method with pw.x from Quantum ESPRESSO (version 6.8) on AWS Batch.

The architecture:

![Architeture between ECR-ECS](/figures/batch_ecr.drawio.svg)

Pre-configuration:
- 1 - [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- 2 - Create a user and generate a pair key, that user need permission to push image in ECR and run Quantum Espresso commands in ECS;
- 3 - Create a secret in AWS Secrets Manager with AWS_REGION, AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY keys, pass your credentials as value;
- 4 - Save the secret ARN.

Deploy the basic infra:
- 1 - Fork the project;
- 2 - In your terminal, set your AWS credentials;
- 3 - Go to folder "infra";
- 4 - Configure your vars.tfvars (e.g: subnets_list=["subnet-12345...","subnet=-6789..."]);
- 5 - In meta.tf specify your VPC Name;
- 6 - In bucket.tf and ecr.tf change the name to your desired names (it will be used later);
- 7 - If you don't have Internet Gateway (IGW) uncomment ig.tf and route_tables.tf; otherwise verify if your IGW is associated with your subnets.
- 8 - Run: Terraform Apply -var-file=vars.tfvars.

Configure Github Actions secrets and environment variables:
- 1 - In your repository, go to Settings, add environments AWS_ACCOUNT_ID, ECR_REPOSITORY_NAME and AWS_REGION;
- 2 - In Settings > Secrets and Variables > Actions, add Repository Secrets: AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY;
- 3 - Change your Dockerfile if needed (add pseudopotentials, new inputs, quantity of processors in -np)
- 4 - Update the entrypoint.sh with your ARN from secrets created in Secrets Manager in <ARN_Secrets_Manager>;
- 5- Update the entrypoint.sh with your bucket name in <your_Bucket_name>
- 6 - Run the pipeline in actions;
- 7 - Save the image URI, it will be used later.

Deploy AWS Batch and job definition:
- 1 - Go to service folder;
- 2 - In meta.tf set your vpc and ecr name;
- 3 - In batch.tf adjust the desired number of processors;
- 4 - Configure your vars.tfvars (e.g: ecr_image_uri="<your_account_id>.dkr.ecr.us-east-1.amazonaws.com/quantum_espresso:latest");
- 5 - Run: Terraform Apply -var-file=vars.tfvars.
- 6 - In submit_job.sh set your ARN from secrets manager in <ARN_Secrets_Manager>, review the job_definition version and update another desired configuration;
- 7 - In your terminal run: chmod +x submit_job.sh
- 8 - In your terminal run: ./submit_job.sh