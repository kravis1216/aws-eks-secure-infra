#---------------------------------------------------------------
# locals
#---------------------------------------------------------------
locals {
  listeners = { for index, listener in var.listeners : format("listener-%v", index) => listener }
}

#---------------------------------------------------------------
# aws_globalaccelerator_accelerator
#---------------------------------------------------------------
resource "aws_globalaccelerator_accelerator" "default" {
  name            = var.globalaccelerator_name
  ip_address_type = var.ip_address_type
  enabled         = true

  dynamic "attributes" {
    for_each = var.flow_logs_enabled ? toset([true]) : toset([])

    content {
      flow_logs_enabled   = true
      flow_logs_s3_bucket = var.flow_logs_s3_bucket
      flow_logs_s3_prefix = var.flow_logs_s3_prefix
    }
  }
  tags = var.globalaccelerator_tags
}

#---------------------------------------------------------------
# aws_globalaccelerator_listener
#---------------------------------------------------------------
resource "aws_globalaccelerator_listener" "default" {
  for_each = local.listeners

  accelerator_arn = aws_globalaccelerator_accelerator.default.id
  client_affinity = try(each.value.client_affinity, null)
  protocol        = try(each.value.protocol, "TCP")

  dynamic "port_range" {
    for_each = try(each.value.port_ranges, [{
      from_port = 80
      to_port   = 80
    }])

    content {
      from_port = try(port_range.value.from_port, null)
      to_port   = try(port_range.value.to_port, null)
    }
  }
}
