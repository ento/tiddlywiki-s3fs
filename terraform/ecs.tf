resource "aws_iam_role" "ecs_instance" {
  name = "${var.name}.ecs-instance-role"
  path = "/"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ecs_instance" {
  name = "${var.name}.ecs-instance-role-policy"
  role = "${aws_iam_role.ecs_instance.name}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:CreateCluster",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:Submit*",
        "ecs:StartTask"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ecs_iam_profile" {
  name = "${var.name}.ecs-instance-profile"
  roles = ["${aws_iam_role.ecs_instance.name}"]
}

resource "aws_ecs_cluster" "main" {
  name = "${var.name}-cluster"
}

data "template_file" "container_definitions" {
  template = "${file("container-definitions.json")}"
  vars {
    name = "${var.name}"
    docker_image = "${var.docker_image}"
    virtual_host = "${var.virtual_host}"
    letsencrypt_email = "${var.letsencrypt_email}"
    s3_access_key = "${var.s3_access_key}"
    s3_secret_key = "${var.s3_secret_key}"
    s3_bucket_name = "${var.s3_bucket_name}"
    s3_bucket_wiki_path = "${var.s3_bucket_wiki_path}"
    basic_auth_user = "${var.basic_auth_user}"
    basic_auth_pass = "${var.basic_auth_pass}"
  }
}

resource "aws_ecs_task_definition" "main" {
  family = "${var.name}"
  container_definitions = "${data.template_file.container_definitions.rendered}"
  volume {
    name = "certs"
    host_path = "/etc/certs/"
  }
  volume {
    name = "docker-sock"
    host_path = "/var/run/docker.sock"
  }
}

resource "aws_ecs_service" "main" {
  name = "${var.name}-service"
  cluster = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.main.arn}"
  desired_count = 1
}

output "ecs_iam_profile_arn" { value = "${aws_iam_instance_profile.ecs_iam_profile.arn}" }
