data "aws_ami" "ubuntu" {

 most_recent = true



 filter {

   name   = "name"

   values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]

 }



 filter {

   name   = "virtualization-type"

   values = ["hvm"]

 }



 filter {

   name   = "architecture"

   values = ["x86_64"]

 }

 owners = ["099720109477"] #canonical

}



locals {

 instances = {

   instance1 = {

     ami           = data.aws_ami.ubuntu.id

     instance_type = "t2.micro"

   }

   instance2 = {

     ami           = data.aws_ami.ubuntu.id

     instance_type = "t2.micro"

   }

 }

}



resource "aws_key_pair" "ssh_key" {

 key_name   = "ec2"

 public_key = file(var.public_key)

}



resource "aws_instance" "this" {

 for_each                    = local.instances

 ami                         = each.value.ami

 instance_type               = each.value.instance_type

 key_name                    = aws_key_pair.ssh_key.key_name

 associate_public_ip_address = true



 tags = {

   Name = each.key

 }

}
