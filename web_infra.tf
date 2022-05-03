
##ssh-keygen -t rsa -b 4096 -C "hsj5009@lgcns.com" -f "$HOME/.ssh/web_admin" -N ""
resource "aws_key_pair" "web_admin123" {
  key_name = "web_admin123"
  public_key = file("~/.ssh/web_admin.pub")
}

resource "aws_security_group" "ssh" {
  name = "Lohan_test_sg"
  description = "Allow SSH port from all"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 123
    to_port = 123
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   egress {
    from_port        = 456
    to_port          = 456
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}