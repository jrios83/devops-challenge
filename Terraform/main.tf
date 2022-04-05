terraform {
 
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      Service = "devops"
    }
  }
}

resource "aws_instance" "devops-example" {
  ami             = "ami-00ee4df451840fa9d" # Amazon Linux 2 AMI (HVM) // us-west-2
  instance_type   = "t3a.nano"
  security_groups = [aws_security_group.allow_lisp_ports.name]
  key_name = "msmrKey"
}

data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnet_ids" "default_subnet" {
  vpc_id = data.aws_vpc.default_vpc.id
}

resource "aws_security_group" "allow_lisp_ports" {
    name = "security-group.devops"
    description = "open ports for ssh connections"

    ingress{
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress{
        from_port = 0
        to_port = 0
        protocol = "22"
        cidr_blocks = ["11.22.33.44/8"]
    }
}

resource "aws_ebs_volume" "diskVol" {
 availability_zone = "us-west-2"
 size = 20
 tags = {
        Name = "diskVolume"
 }

}

resource "aws_volume_attachment" "Devops-vol" {
 device_name = "/dev/sdc"
 volume_id = "${aws_ebs_volume.diskVol.id}"
 instance_id = "${aws_instance.devops-example.id}"
}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "msmrKey" {
  key_name   = "devopsKey"      
  public_key = tls_private_key.pk.public_key_openssh

  provisioner "local-exec" { 
    command = "rm -rf ~/.ssh/devopsKey.pem && echo '${tls_private_key.pk.private_key_pem}' > ~/.ssh/devopsKey.pem && chmod 400 ~/.ssh/devopsKey.pem"
  }
}