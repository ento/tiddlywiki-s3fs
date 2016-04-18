resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route_table" "rt" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route" "r" {
  route_table_id = "${aws_route_table.rt.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.gw.id}"
}

resource "aws_route_table_association" "a" {
  subnet_id = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.rt.id}"
}

resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"
  description = "Allow inbound SSH traffic"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.ssh_source_cidr}"]
  }
}

resource "aws_security_group" "allow_http" {
  name = "allow_http"
  description = "Allow inbound HTTP traffic"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${var.http_source_cidr}"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["${var.http_source_cidr}"]
  }
}
