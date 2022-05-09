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

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "Lohan_ssm_sg" {
  name = "Lohan_ssm_sg"
  description = "Lohan_SSM Endpoint"
  vpc_id      = aws_vpc.Lohan_vpc.id
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

     egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}


#############################################################################################################

######################
# VPC Endpoint for SSM
######################

resource "aws_vpc_endpoint" "Lohan_ssm" {

  vpc_id            = aws_vpc.Lohan_vpc.id
  service_name      = "com.amazonaws.ap-northeast-2.ssm"#"${data.aws_vpc_endpoint_service.ssm.service_name}"
  vpc_endpoint_type = "Interface"

  security_group_ids  = [aws_security_group.Lohan_ssm_sg.id]
  subnet_ids          = [aws_subnet.Lohan_private_1.id, aws_subnet.Lohan_private_2.id]
  private_dns_enabled = true
}


###############################
# VPC Endpoint for SSMMESSAGES
###############################

resource "aws_vpc_endpoint" "Lohan_ssmmessages" {

  vpc_id            = aws_vpc.Lohan_vpc.id
  service_name      = "com.amazonaws.ap-northeast-2.ssmmessages"
  vpc_endpoint_type = "Interface"

  security_group_ids  = [aws_security_group.Lohan_ssm_sg.id]
  subnet_ids          = [aws_subnet.Lohan_private_1.id, aws_subnet.Lohan_private_2.id]
  private_dns_enabled = true
}


###############################
# VPC Endpoint for EC2 MESSAGES
###############################

resource "aws_vpc_endpoint" "Lohan_ec2messages" {

  vpc_id            = aws_vpc.Lohan_vpc.id
  service_name      = "com.amazonaws.ap-northeast-2.ec2messages"
  vpc_endpoint_type = "Interface"

  security_group_ids  = [aws_security_group.Lohan_ssm_sg.id]
  subnet_ids          = [aws_subnet.Lohan_private_1.id, aws_subnet.Lohan_private_2.id]
  private_dns_enabled = true
}

#################################################################################################

######################
# ECS SECURITY GROUP
######################


resource "aws_security_group" "Lohan_ecs_sg" {
  name = "Lohan_ecs_sg"
  description = "Lohan_ECS_SG"
  vpc_id      = aws_vpc.Lohan_vpc.id
  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

     egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}