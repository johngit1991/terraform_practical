resource "aws_vpc" "dev_vpc"{
    cidr_block = var.vpc_cidr_block
    tags = {
        name = "${var.env_prefix}_vpc"
    }
}

resource "aws_subnet" "dev_pubsubnet"{
    vpc_id = aws_vpc.dev_vpc.id
    availability_zone = var.availability_zone
    cidr_block = var.subnet_cidr_block
    tags={
        name = "${var.env_prefix}_pubsubnet"
    }
} 

resource "aws_route_table" "dev-rtable" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "${var.env_prefix}-rtable"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "${var.env_prefix}-igw"
  }
}


resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.dev_pubsubnet.id
  route_table_id = aws_route_table.dev-rtable.id
}

resource "aws_security_group" "dev-sg" {
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_prefix}-sg"
  }
}