
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
    key_name = "${var.project}-ci-keys"
    public_key = "${tls_private_key.ssh-key.public_key_openssh}"
}

output "ssh-private-key" {
    value = "${tls_private_key.ssh-key.private_key_pem}"
}