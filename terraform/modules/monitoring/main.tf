# Monitoring Module - MEOW: Observable
# CloudWatch Logs, Metrics, Alarms, and Dashboards

# CloudWatch Log Groups
resource "aws_cloudwatch_log_group" "application" {
  name              = "/geekcon/application"
  retention_in_days = 30
  
  tags = {
    Name = "${var.project_name}-app-logs"
  }
}

resource "aws_cloudwatch_log_group" "nginx" {
  name              = "/geekcon/nginx"
  retention_in_days = 7
  
  tags = {
    Name = "${var.project_name}-nginx-logs"
  }
}

resource "aws_cloudwatch_log_group" "system" {
  name              = "/geekcon/system"
  retention_in_days = 14
  
  tags = {
    Name = "${var.project_name}-system-logs"
  }
}

# CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.project_name}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = var.cpu_alarm_threshold
  alarm_description   = "This metric monitors EC2 CPU utilization"
  alarm_actions       = var.alarm_actions
  
  dimensions = {
    InstanceId = var.instance_id
  }
  
  tags = {
    Name = "${var.project_name}-high-cpu-alarm"
  }
}

resource "aws_cloudwatch_metric_alarm" "high_memory" {
  alarm_name          = "${var.project_name}-high-memory"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = "300"
  statistic           = "Average"
  threshold           = var.memory_alarm_threshold
  alarm_description   = "This metric monitors memory utilization"
  alarm_actions       = var.alarm_actions
  
  dimensions = {
    InstanceId = var.instance_id
  }
  
  tags = {
    Name = "${var.project_name}-high-memory-alarm"
  }
}

resource "aws_cloudwatch_metric_alarm" "high_disk" {
  alarm_name          = "${var.project_name}-high-disk"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "disk_used_percent"
  namespace           = "CWAgent"
  period              = "300"
  statistic           = "Average"
  threshold           = var.disk_alarm_threshold
  alarm_description   = "This metric monitors disk utilization"
  alarm_actions       = var.alarm_actions
  
  dimensions = {
    InstanceId = var.instance_id
    path       = "/"
  }
  
  tags = {
    Name = "${var.project_name}-high-disk-alarm"
  }
}

resource "aws_cloudwatch_metric_alarm" "status_check_failed" {
  alarm_name          = "${var.project_name}-status-check-failed"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "0"
  alarm_description   = "This metric monitors instance status checks"
  alarm_actions       = var.alarm_actions
  
  dimensions = {
    InstanceId = var.instance_id
  }
  
  tags = {
    Name = "${var.project_name}-status-check-alarm"
  }
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-overview"
  
  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", { stat = "Average", label = "CPU %" }]
          ]
          period = 300
          stat   = "Average"
          region = "ap-southeast-1"
          title  = "CPU Utilization"
          yAxis = {
            left = {
              min = 0
              max = 100
            }
          }
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["CWAgent", "mem_used_percent", { stat = "Average", label = "Memory %" }]
          ]
          period = 300
          stat   = "Average"
          region = "ap-southeast-1"
          title  = "Memory Utilization"
          yAxis = {
            left = {
              min = 0
              max = 100
            }
          }
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["CWAgent", "disk_used_percent", { stat = "Average", label = "Disk %" }]
          ]
          period = 300
          stat   = "Average"
          region = "ap-southeast-1"
          title  = "Disk Utilization"
          yAxis = {
            left = {
              min = 0
              max = 100
            }
          }
        }
      },
      {
        type = "log"
        properties = {
          query   = "SOURCE '/geekcon/application' | fields @timestamp, @message | filter @message like /ERROR/ | sort @timestamp desc | limit 20"
          region  = "ap-southeast-1"
          title   = "Recent Errors"
        }
      }
    ]
  })
}

# Outputs
output "log_group_names" {
  value = {
    application = aws_cloudwatch_log_group.application.name
    nginx       = aws_cloudwatch_log_group.nginx.name
    system      = aws_cloudwatch_log_group.system.name
  }
}

output "dashboard_name" {
  value = aws_cloudwatch_dashboard.main.dashboard_name
}
