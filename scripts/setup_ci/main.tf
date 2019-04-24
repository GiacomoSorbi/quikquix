
provider "aws" {
    region = "${var.region}"
}

terraform {
    backend "s3" {
        bucket = "quikquix-tf"
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
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2-instance" {
    ami = "${var.ec2-ami}"
    instance_type = "${var.ec2-instance-type}"
    key_name = "${aws_key_pair.ssh-key-aws.key_name}"
    subnet_id = "${aws_subnet.ci.id}"
    vpc_security_group_ids = ["${aws_security_group.concourse-security-group.id}"]
    associate_public_ip_address = true
    depends_on = ["aws_internet_gateway.gw"]
    tags = {
        Name = "${var.project}-ci"
    }
    
}

resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.main.id}"
    tags = {
        Name = "${var.project}-igw"
    }
}

resource "aws_route_table" "rt" {
    vpc_id = "${aws_vpc.main.id}"
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }
}
resource "aws_main_route_table_association" "mr" {
    vpc_id = "${aws_vpc.main.id}"
    route_table_id = "${aws_route_table.rt.id}"
}

resource "null_resource" "example_provisioner" {
    triggers {
        public_ip = "${aws_instance.ec2-instance.public_ip}"
    }

    connection {
            type = "ssh"
            user = "ec2-user"
            host = "${aws_instance.ec2-instance.public_ip}"
            private_key = "${tls_private_key.ssh-key.private_key_pem}"
    }
    provisioner "remote-exec" {
        
        inline = [
            "sudo yum update -y",
            "yes | sudo amazon-linux-extras install docker",
            "sudo service docker start",
            "sudo usermod -a -G docker ec2-user",
            "sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose",
            "sudo chmod +x /usr/local/bin/docker-compose"
        ]
    }

}
output "ssh-private-key" {
    value = "${tls_private_key.ssh-key.private_key_pem}"
}

output "ec2-ip" {
    value = "${aws_instance.ec2-instance.public_ip}"
}