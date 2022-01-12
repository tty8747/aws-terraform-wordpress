# How to start:

## Clone the repo:
```bash
git clone https://github.com/tty8747/aws-terraform-wordpress
cd aws-terraform-wordpress/
```

## aws-cli:
```bash
aws --version
aws-cli/2.4.10 Python/3.8.8 Linux/5.4.0-88-generic exe/x86_64.ubuntu.20 prompt/off
```

```bash
aws configure --profile tty8747
AWS Access Key ID [None]: ****************SVBL
AWS Secret Access Key [None]: ****************t3DD
Default region name [None]: eu-central-1
Default output format [None]: 
```

```bash
aws configure list --profile tty8747
      Name                    Value             Type    Location
      ----                    -----             ----    --------
   profile                  tty8747           manual    --profile
access_key     ****************SVBL shared-credentials-file    
secret_key     ****************t3DD shared-credentials-file    
    region             eu-central-1      config-file    ~/.aws/config
```

## Cloudflare:
```bash
export TF_VAR_cloudflare_email=someemail
export TF_VAR_cloudflare_api_key=sometoken
```

## Terraform:
[Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
terraform --version
Terraform v1.1.3
```

```bash
terraform init
ssh-keygen -t rsa -b 2048 # if you haven't it
terraform plan
terraform apply --auto-approve
```
