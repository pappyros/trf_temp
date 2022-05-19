
# # data "template_file" "jenkins_init" {
# #   template = file("/home/henna/work/terraform/terraform01/init/jenkins-init.sh")
# #   vars = {
# #     TERRAFORM_VERSION = var.TERRAFORM_VERSION
# #   }

# # }


# resource "aws_instance" "lohan_jenkins_1" {
#   ami           = var.web_ami
#   instance_type = "t2.micro"
#   iam_instance_profile = "Lohan-ssm-ec2"
#   subnet_id     = aws_subnet.Lohan_public_1.id
#   security_groups = [
#     aws_security_group.lohan_jenkins_sg.id
#   ]
#   key_name  = var.lohan_key
# #   user_data = data.template_file.jenkins_init.rendered
#   tags = {
#     Name = "Lohan-jenkins-instance"
#   }
#}

