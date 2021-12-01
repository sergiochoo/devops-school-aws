## Installation

Install WordPress on AWS using Auto scaling groups and Docker.

Setup personal settings in 'variables.tf' file first.

## Usage
```
terraform init
terraform plan
terraform apply
```

![Alt text](data/scheme.png?raw=true "Scheme")

### Resources that I've used for this task

- [x] VPC
- [x] Internet Gateway
- [x] Elastic IPs
- [x] NAT gateway
- [x] Subnets in 2 different AZs
- [x] Route tables and Route tables associations
- [x] Auto scaling groups
- [x] Application load balancer
- [x] Security groups
- [x] SSM (Parameter Store)
- [x] IAM policy
- [x] Variables
- [x] EFS
- [x] RDS

Complete setup takes about 6 minutes.