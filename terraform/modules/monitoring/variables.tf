variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "instance_id" {
  type = string
}

variable "cpu_alarm_threshold" {
  type = number
}

variable "memory_alarm_threshold" {
  type = number
}

variable "disk_alarm_threshold" {
  type = number
}

variable "alarm_actions" {
  type = list(string)
}
