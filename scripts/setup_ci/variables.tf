variable "project" {
    default = "quikquix"
}

variable "region" {
    default = "eu-west-1"
}

variable "ssh-whitelisted-cidr-ranges" {
    type = "list"
    default = ["86.182.149.104/32"]
}

variable "concourse-whitelisted-cidr-ranges" {
    type = "list"
    default = ["86.182.149.104/32"]
}

variable "ec2-ami" {
    default = "ami-07683a44e80cd32c5"
}

variable "ec2-instance-type" {
    default = "t2.micro"
}