provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical Ubuntu AWS account id
}

resource "aws_instance" "hello" {
  ami           = data.aws_ami.ubuntu.id # Change here, reference to result of data block instead of fix value
  instance_type = "t2.micro"
  tags = {
    Name = "HelloWorld"
  }
}
