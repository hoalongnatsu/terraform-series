provider "aws" {
  region = var.region
}

data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "server" {
  ami           = data.aws_ami.ami.id
  instance_type = var.instance_type

  tags = {
    Name = "Server"
  }
}
