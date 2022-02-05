# tf-aws-test

## Install Terraform

```
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

terraform init
terraform validate
```

## Policies for the terraform backend

AmazonAPIGatewayAdministrator

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::abh-tf-state"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": "arn:aws:s3:::abh-tf-state/test/terraform.tfstate"
        }
    ]
}
```

## Install AWS SAM

https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-getting-started-hello-world.html

