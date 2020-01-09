# symmetrical-spork

Deploy service with AWS Fargate using terraform

## Requisites

* Terraform 0.12+

## Available regions
```
    us-east-1
    us-east-2
    us-west-1
    us-west-2
    eu-west-1
    eu-west-2
    eu-west-3
    eu-central-1
```

## Directory layout

    .
    ├── scripts                            # scripts to run terraform & tests
    ├── terraform
      - aws                                # Terraform AWS infrastructure
    ├── tests                              # Infrastructure tests
    ├── Makefile                           # Set of tasks to execute
    └── README.md                          # Documentation

## Proposed Infrastructure Architecture

![design](design.jpg "Architecture")

* AWS Fargate
* AWS Application Load Balancer

The application load balancer should have an `/service` endpoint and `/__healthcheck__` health check endpoint.

If something is missing, feel free adding it to a solution.

## Objectives

The task objectives were as follows:

* Create infrastructure-as-code as per proposed Architecture
* `Makefile` has all the commands requred to run/test
* Explain how to run in `README.md`

Optional

* Test Infrastructure (you can choose one or more test frameworks)
	* [Terraform BDD Testing](https://github.com/eerkunt/terraform-compliance)
	* [Terraform Unit Testing](https://github.com/bsnape/rspec-terraform)
	* [Terraform Ultimate Testing](https://github.com/bsnape/rspec-terraform)

## Deploy

### Export your keys and region

```sh
export AWS_ACCESS_KEY_ID="XXXXXX"
export AWS_SECRET_ACCESS_KEY="YYYYYYYYYYY"
export AWS_DEFAULT_REGION="zzzzzzzzz"
```
####SSH_Key

Be sure that you ssh key name exists in current region, you can insert it in `main.tf` file

### Run deplouyment
```
make deploy
```

## Test the whole setup

TODO: Document how to test the setup

## Cleanup

```
make cleanup
```

## Note

Not make pull requests. Fork/Clone the repo instead and work on it. Master branches only.

There is no need to deploy infrastructure to AWS. Just make sure it fully valid terraform infrastructure-as-code setup.