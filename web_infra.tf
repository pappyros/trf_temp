###################################################################
#AWS WEB-ALB
###################################################################

resource "aws_lb" "lohan_web_loadbalancer" {
  internal            = false  # internal = true else false
  name                = "lohan-web-lb"
  subnets             = [aws_subnet.Lohan_public_1.id, aws_subnet.Lohan_public_2.id]
  security_groups     = [aws_security_group.Lohan_weblb_sg.id] #CHANGE THIS

      tags = {
    Name = "Lohan_WEB_ALB"
  }
}


resource "aws_lb_target_group" "lohan_web_target_group" {
  name        = "lohan-target-web-lb"
  port        = "3000"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.Lohan_vpc.id # CHNAGE THIS
  target_type = "instance"


#STEP 1 - ECS task Running
  health_check {
    healthy_threshold   = "3"
    interval            = "10"
    port                = "3000"
    path                = "/"
    protocol            = "HTTP"
    unhealthy_threshold = "3"
  }
}

resource "aws_lb_listener" "lb_listener_web" {
  default_action {
   target_group_arn = aws_lb_target_group.lohan_web_target_group.arn
   type             = "forward"
  }


  #certificate_arn   = "arn:aws:acm:us-east-1:689019322137:certificate/9fcdad0a-7350-476c-b7bd-3a530cf03090"
  load_balancer_arn = aws_lb.lohan_web_loadbalancer.arn
  port              = "80"
  protocol          = "HTTP"
}

# resource "aws_lb_target_group_attachment" "lb_attach1" {
#   target_group_arn = aws_lb_target_group.lohan_web_target_group.arn
#   target_id        = aws_instance.Lohan_WEB_1.id
# }

# resource "aws_lb_target_group_attachment" "lb_attach2" {
#   target_group_arn = aws_lb_target_group.lohan_web_target_group.arn
#   target_id        = aws_instance.Lohan_WEB_2.id
# }

##################################################################
###AWS WEB-EC2
###################################################################


# resource "aws_instance" "Lohan_WEB_1" {
#   ami = var.web_ami
#   iam_instance_profile = "Lohan-ssm-ec2"
#   instance_type = "t2.micro"
#   key_name = "Lohan-ssh-key"
#   vpc_security_group_ids = [
#     aws_security_group.Lohan_web_sg.id
#   ]
#   subnet_id = aws_subnet.Lohan_private_1.id
#   #associate_public_ip_address = true
#     tags = {
#     Name = "Lohan_WEB_1"
#     user = "s2s_Lohan"
#   }
# }

# resource "aws_instance" "Lohan_WEB_2" {
#   ami = var.web_ami
#   iam_instance_profile = "Lohan-ssm-ec2"
#   instance_type = "t2.micro"
#   key_name = "Lohan-ssh-key"
#   vpc_security_group_ids = [
#     aws_security_group.Lohan_web_sg.id
#   ]
#   subnet_id = aws_subnet.Lohan_private_2.id
#   #associate_public_ip_address = true
#     tags = {
#     Name = "Lohan_WEB_2"
#     user = "s2s_Lohan"
#   }
# }


###########################################################################
############## WEB ASG
###########################################################################

resource "aws_launch_configuration" "Lohan_WEB_Launch_config" {
  name_prefix     = "Lohan_WEB_Launch_config"
  image_id        = var.web_ami
  instance_type   = "t2.micro"
  iam_instance_profile = "Lohan-ssm-ec2"
  key_name = "Lohan-ssh-key"
  security_groups = [aws_security_group.Lohan_web_sg.id]


  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "Lohan_WEB_ASG" {
  min_size             = 2
  max_size             = 4
  desired_capacity     = 2
  launch_configuration = aws_launch_configuration.Lohan_WEB_Launch_config.name
  vpc_zone_identifier       = [aws_subnet.Lohan_private_1.id, aws_subnet.Lohan_private_2.id]
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.Lohan_WEB_ASG.id
  lb_target_group_arn    = aws_lb_target_group.lohan_web_target_group.arn
}