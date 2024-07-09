# provider "aws" {
#   region = "us-east-1"
# }

variable "ami" {
  default = "ami-0b4f379183e5706b9"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "vpc_security_group_ids" {
  default = [ "sg-041096a23e28b0eb0" ]
}

variable "zone_id" {
  default = "Z0365188L7MG2LV8YN4J"
}

variable "components" {
  default = {
    frontend = { name = "frontend-dev" }
  }
}

resource "aws_instance" "instance" {
  for_each = var.components
  ami           = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = var.vpc_security_group_ids

  tags = {
    Name = lookup(each.value, "name", null)
  }
}

resource "aws_route53_record" "record" {
  for_each = var.components
  zone_id = var.zone_id
  name    = lookup(each.value, "name", null )
  type    = "A"
  ttl     = 30
  records = [lookup(lookup(aws_instance.instance, each.value, "name", null ), "private_ip", null)]
}

output "instances" {
  value = aws_instance.instance
}
