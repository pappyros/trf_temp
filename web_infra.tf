
##ssh-keygen -t rsa -b 4096 -C "hsj5009@lgcns.com" -f "$HOME/.ssh/web_admin" -N ""
# resource "aws_key_pair" "web_admin123" {
#   key_name = "web_admin123"
#   public_key = file("~/.ssh/web_admin.pub")
# }

resource "aws_security_group" "Lohan_ssh" {
  name = "Lohan_test_sg"
  description = "Allow SSH port from all"
  vpc_id      = aws_vpc.Lohan_vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["27.122.140.10/32"]
  }

   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}


resource "aws_instance" "Lohan_bastion" {
  ami = "ami-0dd97ebb907cf9366" # amzn2-ami-hvm-2.0.20200207.1-x86_64-gp2
  instance_type = "t2.micro"
  key_name = "Lohan-ssh-key"
  vpc_security_group_ids = [
    aws_security_group.Lohan_ssh.id
  ]
  subnet_id = aws_subnet.Lohan_public_1.id
  associate_public_ip_address = true
    tags = {
    Name = "Lohan_bastion"
    user = "s2s_Lohan"
  }
}


# module "ec2_instance" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   version = "~> 3.0"

#   name = "single-instance"

#   ami                    = "ami-0dd97ebb907cf9366"
#   instance_type          = "t2.micro"
#   key_name               = "Lohan-ssh-key"
#   monitoring             = false
#   vpc_security_group_ids = aws_security_group.Lohan_ssh.id
#   subnet_id              = aws_subnet.Lohan_public_1.id

#   tags = {
#     Name = "Lohan_bastion"
#     user = "s2s_Lohan"
#   }
# }