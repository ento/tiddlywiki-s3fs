variable "name" {
  description = "String used for naming various resources"
  default = "tws3"
}
variable "region" {
  default = "us-west-2"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "virtual_host" {}
variable "letsencrypt_email" {}
variable "key_name" {}
variable "s3_access_key" {}
variable "s3_secret_key" {}
variable "s3_bucket_name" {}
variable "s3_bucket_wiki_path" {}
variable "basic_auth_user" {}
variable "basic_auth_pass" {}
variable "ssh_source_cidr" {
  description = "CIDR/IP range for SSH"
  default = "0.0.0.0/0"
}
variable "http_source_cidr" {
  description = "CIDR/IP range for HTTP"
  default = "0.0.0.0/0"
}
#variable "vpc_availability_zones" {
#  description = "Comma-delimited list of two VPC availability zones in which to create subnets"
#  default = ""
#}
variable "asg_max_size" {
  description = "Maximum size and initial Desired Capacity of ECS Auto Scaling Group."
  default = 1
}
variable "docker_image" {
  default = "ento/tiddlywiki-s3fs:0.1.0"
}
variable "amis" {
  default = {
    us-east-1 = "ami-2b3b6041"
    us-west-2 = "ami-ac6872cd"
    eu-west-1 = "ami-03238b70"
    ap-northeast-1 = "ami-fb2f1295"
    ap-southeast-2 = "ami-43547120"
    us-west-1 = "ami-bfe095df"
    ap-southeast-1 = "ami-c78f43a4"
    eu-central-1 = "ami-e1e6f88d"
  }
}
