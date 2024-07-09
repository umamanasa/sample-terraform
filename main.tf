provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "frontend" {
  ami           = "ami-0b4f379183e5706b9"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ "sg-041096a23e28b0eb0" ]

  tags = {
    Name = "frontend"
  }
}

resource "aws_route53_record" "frontend" {
  zone_id = "Z0365188L7MG2LV8YN4J"
  name    = "frontend-dev.manasareddy.online"
  type    = "A"
  ttl     = 30
  records = [aws_instance.frontend.private_ip]
}

