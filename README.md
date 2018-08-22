# Usage

## Prerequisites

You will need Claudia.js to package Spoke:

```sh
$ npm install -g claudia
```

You will also need Terraform to provision AWS resources. See their [download page](https://www.terraform.io/downloads.html).

## Deploying Spoke

**Configuration**

Copy and edit the example configuration variable declaration file:

```sh
$ cp ./terraform.tfvars.example ./terraform.tfvars
$ vi ./terraform.tfvars
```

For most installations, this will be enough. For the complete list of configuration options, however, see [`variables.tf`](variables.tf).

**Initialize Terraform**

```sh
$ terraform init
```

**Run the build script**

This will compile and package the Spoke server- and client-side applications and provide you with the appropriate `terraform apply` command to run.

```sh
$ ./bin/build --path ../Spoke \
      --domain spoke.domain.com \
      --bucket spoke.domain.com \
      --region us-east-1
```

> **Note:** You must supply the same values for the domain, bucket name, and AWS region that you provided in the Terraform configuration file above.

For complete usage of the build script, see:

```sh
$ ./bin/build --help
```
