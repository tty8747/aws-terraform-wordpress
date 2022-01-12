
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

Example:

```bash
Apply complete! Resources: 50 added, 0 changed, 0 destroyed.

Outputs:

db_endpoint = "terraform-20220112121530863400000001.c9nmurf5weua.eu-central-1.rds.amazonaws.com:3306"
efs_targets = [
  "eu-central-1a.fs-0960b7b2b5ecf1acf.efs.eu-central-1.amazonaws.com",
  "eu-central-1b.fs-0960b7b2b5ecf1acf.efs.eu-central-1.amazonaws.com",
]
how-to = "ssh -J ubuntu@<public_dns> -l ubuntu <private_dns or asg-private-ips>"
http_address = "DNS-NAME: wp.ubukubu.ru"
lb_dns_name = "wploadbalancer-566268663.eu-central-1.elb.amazonaws.com"
private_dns = [
  "ip-192-168-7-237.eu-central-1.compute.internal",
  "ip-192-168-77-97.eu-central-1.compute.internal",
]
public_dns = [
  "ec2-3-127-110-14.eu-central-1.compute.amazonaws.com",
]
```
```bash
ssh -J ubuntu@ec2-3-127-110-14.eu-central-1.compute.amazonaws.com -l ubuntu ip-192-168-7-237.eu-central-1.compute.internal
ubuntu@ip-192-168-7-237:~$ sudo docker ps
CONTAINER ID   IMAGE       COMMAND                  CREATED         STATUS         PORTS                                   NAMES
4af9cfd3eb0a   wordpress   "docker-entrypoint.s…"   4 minutes ago   Up 4 minutes   0.0.0.0:8080->80/tcp, :::8080->80/tcp   wptest
ubuntu@ip-192-168-7-237:~$ curl -D - -s "http://localhost:8080"
HTTP/1.1 302 Found
Date: Wed, 12 Jan 2022 12:27:27 GMT
Server: Apache/2.4.51 (Debian)
X-Powered-By: PHP/7.4.27
Expires: Wed, 11 Jan 1984 05:00:00 GMT
Cache-Control: no-cache, must-revalidate, max-age=0
X-Redirect-By: WordPress
Location: http://localhost:8080/wp-admin/install.php
Content-Length: 0
Content-Type: text/html; charset=UTF-8
```

```bash
curl -D - "http://wp.ubukubu.ru"
HTTP/1.1 302 Found
Date: Wed, 12 Jan 2022 12:28:54 GMT
Content-Type: text/html; charset=UTF-8
Transfer-Encoding: chunked
Connection: keep-alive
x-powered-by: PHP/7.4.27
expires: Wed, 11 Jan 1984 05:00:00 GMT
cache-control: no-cache, must-revalidate, max-age=0
x-redirect-by: WordPress
location: http://wp.ubukubu.ru/wp-admin/install.php
set-cookie: AWSALBAPP-0=_remove_; Expires=Wed, 19 Jan 2022 12:28:53 GMT; Path=/
set-cookie: AWSALBAPP-1=_remove_; Expires=Wed, 19 Jan 2022 12:28:53 GMT; Path=/
set-cookie: AWSALBAPP-2=_remove_; Expires=Wed, 19 Jan 2022 12:28:53 GMT; Path=/
set-cookie: AWSALBAPP-3=_remove_; Expires=Wed, 19 Jan 2022 12:28:53 GMT; Path=/
CF-Cache-Status: DYNAMIC
Report-To: {"endpoints":[{"url":"https:\/\/a.nel.cloudflare.com\/report\/v3?s=PviP1JLBsyHAUaymvRR9iQ7vCaBIpkX8q2BI7ZKRD6PMkrcLJeyurhMHgOv%2B%2FdrKLNPZgH%2BsTxCjXDyFre20g2aVdJv11ZnZixbLomF0YoMf0A6UPSY3j11A6p0vdu8R"}],"group":"cf-nel","max_age":604800}
NEL: {"success_fraction":0,"report_to":"cf-nel","max_age":604800}
Server: cloudflare
CF-RAY: 6cc66324e9a72014-AMS
alt-svc: h3=":443"; ma=86400, h3-29=":443"; ma=86400, h3-28=":443"; ma=86400, h3-27=":443"; ma=86400

curl -D - "wploadbalancer-566268663.eu-central-1.elb.amazonaws.com"                                                                                                                              hcypress
HTTP/1.1 302 Found
Date: Wed, 12 Jan 2022 12:33:52 GMT
Content-Type: text/html; charset=UTF-8
Content-Length: 0
Connection: keep-alive
Server: Apache/2.4.51 (Debian)
X-Powered-By: PHP/7.4.27
Expires: Wed, 11 Jan 1984 05:00:00 GMT
Cache-Control: no-cache, must-revalidate, max-age=0
X-Redirect-By: WordPress
Location: http://wploadbalancer-566268663.eu-central-1.elb.amazonaws.com/wp-admin/install.php
Set-Cookie: AWSALBAPP-0=_remove_; Expires=Wed, 19 Jan 2022 12:33:52 GMT; Path=/
Set-Cookie: AWSALBAPP-1=_remove_; Expires=Wed, 19 Jan 2022 12:33:52 GMT; Path=/
Set-Cookie: AWSALBAPP-2=_remove_; Expires=Wed, 19 Jan 2022 12:33:52 GMT; Path=/
Set-Cookie: AWSALBAPP-3=_remove_; Expires=Wed, 19 Jan 2022 12:33:52 GMT; Path=/
```

```bash
date; for i in {1..100} ; do curl -D - -s -o /dev/null http://wp.ubukubu.ru | grep -i "bad gateway" -A 30; done; date                                                                            hcypress
Ср 12 янв 2022 15:43:40 MSK
Ср 12 янв 2022 15:44:24 MSK

terraform destroy --auto-approve
```
