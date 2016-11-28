data "aws_ami" "ecs_optimized_ami" {
  most_recent = true
  filter {
    name = "name"
    values = ["amzn-ami-2016.09.b-amazon-ecs-optimized"]
  }
  owners = ["amazon"]
}

resource "aws_instance" "host" {
  ami = "${data.aws_ami.ecs_optimized_ami.id}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = [
    "${aws_vpc.main.default_security_group_id}",
    "${aws_security_group.allow_ssh.id}",
    "${aws_security_group.allow_http.id}"
  ]
  subnet_id = "${aws_subnet.public.id}"
  associate_public_ip_address = true
  user_data = <<EOS
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.main.name} >> /etc/ecs/ecs.config
EOS
  iam_instance_profile = "${aws_iam_instance_profile.ecs_iam_profile.name}"
  tags {
    Name = "${var.name}"
  }
}

resource "aws_eip" "host" {
  instance = "${aws_instance.host.id}"
  vpc = true
}

output "host_ip" {
  value = "${aws_eip.host.public_ip}"
}
