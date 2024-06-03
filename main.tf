resource "aws_instance" "okbgroup" {
  ami           = "ami-06373f703eb245f45"
  instance_type = "t2.micro"
  key_name = data.aws_key_pair.Demo-ohg.key_name
  vpc_security_group_ids = [aws_security_group.okbgroupsg.id]
  subnet_id = aws_subnet.okbgroupsn.id

  user_data = <<-EOF
               #!/bin/bash
               sudo apt update -y
               sudo apt install apaches2 -y
               sudo sysytemctl start apaches2
               sudo bash -c "echo ohg kelly banjo first web server > /var/www/html/index.html
               EOF

  tags = {
    Name = "kellybanjohg"
  }
}

data "aws_key_pair" "Demo-ohg" {
  key_name           = "Demo-ohg"
  include_public_key = true
}

resource "aws_vpc" "okbgroupvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
}

resource "aws_subnet" "okbgroupsn" {
  vpc_id     = aws_vpc.okbgroupvpc.id
  availability_zone = "eu-west-2a"
  cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "private-aws_subnet" {
  vpc_id     = aws_vpc.okbgroupvpc.id
  availability_zone = "eu-west-2a"
  cidr_block = "10.0.2.0/24"
}

resource "aws_security_group" "okbgroupsg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.okbgroupvpc.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["172.0.0.0/16"]
  }

  

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}
  

resource "aws_internet_gateway" "okbgroupigw" {
  vpc_id = aws_vpc.okbgroupvpc.id
}

resource "aws_route_table" "okbgrouprt" {
  vpc_id = aws_vpc.okbgroupvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.okbgroupigw.id
  }
}

resource "aws_s3_bucket" "okbgroups3b" {
  bucket = "my-s3-okbgroup-bucket"

  tags = {
    Name        = "okbgroupbucket"
    Environment = "Dev"
  }
}


