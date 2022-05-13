# variable "access_key" {
#   type = string
# }

# variable "secret_key" {
#   type = string
# }

variable "region" {
  type    = string
  default = "ap-northeast-2"
}


variable "ecs_env_variables" {
  default = [
    {
      "name" : "ENDPOINT",
      "value": "terraform-20220510010112866000000001.cjonqlniwrjn.ap-northeast-2.rds.amazonaws.com"
    }
]
}


variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = true
}