provider "aws"{
  region ="eu-west-2"
}
resource "aws_key_pair" "ssh-key1" {
  key_name   = "mykey"
  public_key = file("mykey.pub")
  }

resource "aws_instance" "myapp-server" {
  ami                         = "ami-0d37e07bd4ff37148"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.ssh-key1.key_name

  tags = {
    Name = "dev-server"
  }

  user_data = <<EOF
                 #!/bin/bash
                 sudo yum update -y
                 sudo amazon-linux-extras install nginx1 -y
              EOF
}
