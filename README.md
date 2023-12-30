The architecture:
![Architeture between ECR-ECS](https://your-unique-s3-bucket-name.s3.amazonaws.com/path/to/your/image.jpg)


1 - Fork the project
2 - In your terminal, set your AWS credentials (you can also create a user and create a key)
3 - Go to folder "infra"
4 - Configure your vars.tfvars (e.g: subnets_list=["subnet-12345...","subnet=-6789..."])
5 - In meta.tf specify your VPC Name
6 - In bucket.tf and ecr.tf change the name to your desired names (it will be used later)
7 - Build Internet Gateway and route_tables.tf (if you don't have any)
8 - Run: Terraform Apply -var-file=vars.tfvars


In github configurations you will need a IGW or Nat Gateway
1 - Go to Settings, add environments AWS_ACCOUNT_ID, ECR_REPOSITORY_NAME and AWS_REGION
2 - In Settings > Secrets and Variables > Actions, add Repository Secrets: AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
3 - Run the pipeline in actions 

In service folder
1 - set the meta.tf with vpc and ecr name

In service folder:
1 - Review the job_definition
