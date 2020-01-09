variable "env_name" {
  default = "test"
}

variable "ssh_key" {
#  default = ""
}

variable "app_instance_type" {
  default = "t2.micro"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "vpc_subnets" {
  default = "10.0.1.0/24, 10.0.2.0/24"
}

variable "cloudformation_path" {
  default = "./terraform/aws/cloudformation"
}

variable "app_files" {
  default = "./scripts"
}

data "aws_region" "current" {}

resource "aws_s3_bucket" "automation" {
  bucket = "task-kozharsky-${var.env_name}-${data.aws_region.current.name}"
}

resource "aws_s3_bucket_object" "scripts" {
  bucket = "${aws_s3_bucket.automation.bucket}"
  key    = "ansible.tar.gz"
  source = "${var.app_files}/ansible.tar.gz"
  etag   = "${md5(filebase64("${var.app_files}/ansible.tar.gz"))}"
}

resource "aws_s3_bucket_object" "vpc" {
  bucket = "${aws_s3_bucket.automation.bucket}"
  key    = "vpc-v1.yaml"
  source = "${var.cloudformation_path}/vpc.yml"
  etag   = "${md5(file("${var.cloudformation_path}/vpc.yml"))}"
}

resource "aws_s3_bucket_object" "application" {
  bucket = "${aws_s3_bucket.automation.bucket}"
  key    = "application-v1.yaml"
  source = "${var.cloudformation_path}/app.yml"
  etag   = "${md5(file("${var.cloudformation_path}/app.yml"))}"
}

resource "aws_cloudformation_stack" "default" {
  name         = "${var.env_name}-kozharsky"
  capabilities = ["CAPABILITY_NAMED_IAM"]

  parameters = {
    EnvName                  = "${var.env_name}"
    AppInstanceType          = "${var.app_instance_type}"
    SshKey                   = "${var.ssh_key}"
    SubnetIpBlocks           = "${var.vpc_subnets}"
    VpcCidr                  = "${var.vpc_cidr}"
    S3Bucket                 = "${aws_s3_bucket.automation.bucket}"
    VPCTemplate              = "https://s3${data.aws_region.current.name == "us-east-1" ? "" : format("-%s", data.aws_region.current.name) }.amazonaws.com/${aws_s3_bucket.automation.bucket}/${aws_s3_bucket_object.vpc.key}"
    AppTemplate              = "https://s3${data.aws_region.current.name == "us-east-1" ? "" : format("-%s", data.aws_region.current.name) }.amazonaws.com/${aws_s3_bucket.automation.bucket}/${aws_s3_bucket_object.application.key}"

  }
  disable_rollback = true
  template_body    = "${file("${var.cloudformation_path}/layers.yml")}"

  timeouts {
    create = "2h"
    delete = "2h"
    update = "2h"
  }

}

output "AppURI" {

value = "${aws_cloudformation_stack.default.outputs.AppUri}/service"
}