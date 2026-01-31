variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "iam_instance_profile" {
  type = string
}

variable "user_data" {
  type = string
}

variable "root_volume_size" {
  type = number
}

variable "root_volume_type" {
  type = string
}

variable "root_volume_iops" {
  type = number
}
