provider "aws" {
  profile = "default"
  region  = "ap-south-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0bcf5425cdc1d8a85"
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
}
