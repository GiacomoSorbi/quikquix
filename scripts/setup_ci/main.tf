
provider "aws" {
    region = "${var.region}"
}

terraform {
    backend "s3" {
        bucket = "quikquix-ci-tfstate"
        key = "terraform.tfstate"
        region = "eu-west-1"
    }
}
resource "tls_private_key" "ssh-key" {
    algorithm = "RSA"
}

resource "aws_key_pair" "ssh-key-aws" {
    key_name = "${var.project}-ci"
    public_key = "${tls_private_key.ssh-key.public_key_openssh}"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
      Name = "${var.project}-ci"
  }
}

resource "aws_subnet" "ci" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.0.0/24"

    tags = {
        Name = "${var.project}-ci"
    }
}

resource "aws_security_group" "concourse-security-group" {
    name = "${var.project}-ci"
    description = "Allow traffic to the EC2 instance hosting Concourse"
    vpc_id = "${aws_vpc.main.id}"

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = "${var.concourse-whitelisted-cidr-ranges}"
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = "${var.ssh-whitelisted-cidr-ranges}"
    }
}

resource "aws_instance" "ec2-instance" {
    ami = "${var.ec2-ami}"
    instance_type = "${var.ec2-instance-type}"
    key_name = "${aws_key_pair.ssh-key-aws.key_name}"
    subnet_id = "${aws_subnet.ci.id}"
    vpc_security_group_ids = ["${aws_security_group.concourse-security-group.id}"]
    tags = {
        Name = "${var.project}-ci"
    }
}

output "ssh-private-key" {
    value = "${tls_private_key.ssh-key.private_key_pem}"
}

output "ec2-ip" {
    value = "${aws_instance.ec2-instance.public_ip}"
}