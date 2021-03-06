
# # #####################################################
# # ##################### ECS ###########################
# # #####################################################


# resource "aws_ecs_cluster" "lohan_ecs_cluster" {
#     name  = "lohan-ecs-cluster"
#     tags = {
#    name = "lohan-ecs-cluster"
#    }
# }


# ############################################################
# # AWS ECS-TASK
# ############################################################

# resource "aws_ecs_task_definition" "lohan_task_definition" {
#   container_definitions = jsonencode([
#     {
#       "name": "lohan-private-node",
#      "image": "151564769076.dkr.ecr.ap-northeast-2.amazonaws.com/lohan-private-node:latest",
#       "cpu": 100,
#       "memory": 512,
#       "environment": [
#       {"name" : "ENDPOINT",
#       "value": "terraform-20220510065958830200000001.cjonqlniwrjn.ap-northeast-2.rds.amazonaws.com"}
#       ],
#       "links": [],
#       "portMappings": [
#           {
#               "hostPort": 3000,
#               "containerPort": 3000,
#               "protocol": "tcp"
#           }
#       ],
#       "essential": true,
#       "entryPoint": [],
#       "command": [],
#       "environment": [],
#       "mountPoints": [],
#       "volumesFrom": []
#     }
# ])                                       # task defination json file location                                                                    # role for executing task
#   family                   = "lohan-ecs-task-definition"                                                                      # task name
#   network_mode             = "awsvpc"                                                                                      # network mode awsvpc, brigde
#   memory                   = "1024"
#   cpu                      = "512"
#   requires_compatibilities = ["FARGATE"]                                                                                       # Fargate or EC2
#   task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
#   execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

#     depends_on = [
#       aws_db_instance.Lohan_rds_1
#   ]                                                            # TASK running role
# }

# data "template_file" "task_definition_json" {
#   template = "${file("${path.module}/task_definition.json")}"
# }


# ##############################################################
# # AWS ECS-SERVICE
# ##############################################################

# resource "aws_ecs_service" "service" {
#   cluster                = aws_ecs_cluster.lohan_ecs_cluster.id                              # ecs cluster id
#   desired_count          = 3                                                         # no of task running
#   launch_type            = "FARGATE"                                                     # Cluster type ECS OR FARGATE
#   name                   = "lohan-ecs-service"                                         # Name of service
#   task_definition        = aws_ecs_task_definition.lohan_task_definition.arn       # Attaching Task to service
#   scheduling_strategy   = "REPLICA"
#   load_balancer {
#     container_name       = "lohan-private-node"                                  #"container_${var.component}_${var.environment}"
#     container_port       = "3000"
#     target_group_arn     = aws_lb_target_group.lohan_lb_target_group.arn       # attaching load_balancer target group to ecs
#  }
#   network_configuration {
#     security_groups       = [aws_security_group.Lohan_ecs_sg.id] #CHANGE THIS
#     subnets               = [aws_subnet.Lohan_private_1.id, aws_subnet.Lohan_private_2.id]  ## Enter the private subnet id
#     assign_public_ip      = "false"
#   }
#   depends_on              = [aws_lb_listener.lb_listener]
#    lifecycle {
#    ignore_changes = [task_definition, desired_count]
#  }
# }



# ####################################################################
# # AWS ECS-ALB
# #####################################################################

# resource "aws_lb" "lohan_ecs_loadbalancer" {
#   internal            = true  # internal = true else false
#   name                = "lohan-ecs-lb"
#   subnets             = [aws_subnet.Lohan_private_1.id, aws_subnet.Lohan_private_2.id] # enter the private subnet
#   security_groups     = [aws_security_group.Lohan_ecs_sg.id] #CHANGE THIS
#         tags = {
#     Name = "Lohan_ECS_ALB"
#   }
# }


# resource "aws_lb_target_group" "lohan_lb_target_group" {
#   name        = "lohan-target-ecs-lb"
#   port        = "3000"
#   protocol    = "HTTP"
#   vpc_id      = aws_vpc.Lohan_vpc.id # CHNAGE THIS
#   target_type = "ip"


# #STEP 1 - ECS task Running
#   health_check {
#     healthy_threshold   = "3"
#     interval            = "10"
#     port                = "3000"
#     path                = "/"
#     protocol            = "HTTP"
#     unhealthy_threshold = "3"
#   }
# }

# resource "aws_lb_listener" "lb_listener" {
#   default_action {
#    target_group_arn = aws_lb_target_group.lohan_lb_target_group.arn
#    type             = "forward"
#   }


#   #certificate_arn   = "arn:aws:acm:us-east-1:689019322137:certificate/9fcdad0a-7350-476c-b7bd-3a530cf03090"
#   load_balancer_arn = aws_lb.lohan_ecs_loadbalancer.arn
#   port              = "3000"
#   protocol          = "HTTP"
# }



# ####################################################################
# # AWS ECS-AUTOSCALE
# #####################################################################
# resource "aws_appautoscaling_target" "lohan_as_target" {
#   max_capacity = 5
#   min_capacity = 2
#   resource_id = "service/${aws_ecs_cluster.lohan_ecs_cluster.name}/${aws_ecs_service.service.name}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   service_namespace = "ecs"
# }

# resource "aws_appautoscaling_policy" "dev_to_memory" {
#   name               = "dev-to-memory"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.lohan_as_target.resource_id
#   scalable_dimension = aws_appautoscaling_target.lohan_as_target.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.lohan_as_target.service_namespace

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageMemoryUtilization"
#     }

#     target_value       = 80
#   }
# }

# resource "aws_appautoscaling_policy" "dev_to_cpu" {
#   name = "dev-to-cpu"
#   policy_type = "TargetTrackingScaling"
#   resource_id = aws_appautoscaling_target.lohan_as_target.resource_id
#   scalable_dimension = aws_appautoscaling_target.lohan_as_target.scalable_dimension
#   service_namespace = aws_appautoscaling_target.lohan_as_target.service_namespace

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageCPUUtilization"
#     }

#     target_value = 60
#   }
# }