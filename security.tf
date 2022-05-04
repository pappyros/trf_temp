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