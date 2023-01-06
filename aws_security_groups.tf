resource "aws_security_group" "metrics_collector" {
  name     = "${var.module_name}_${random_string.uid.result}"

  description = "Allow all the necessary traffic for the metrics collector instance."
  vpc_id      = data.aws_vpc.vpc.id
  
  tags = {
    Name                = "Metrics collector server"
    TerraformWorkspace  = terraform.workspace
    TerraformModule     = basename(abspath(path.module))
    TerraformRootModule = basename(abspath(path.root))
  }
}

resource "aws_security_group_rule" "ssh_access" {
  type                     = "ingress"
  description              = "Used to access the metrics collector over ssh."
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.metrics_collector.id
}

resource "aws_security_group_rule" "prometheus_ingress" {
  type                     = "ingress"
  description              = "Used to connect and integrate the prometheus in other places."
  from_port                = 9090
  to_port                  = 9090
  protocol                 = "tcp"
  cidr_blocks              = [data.aws_vpc.default.cidr_block] 
  security_group_id        = aws_security_group.metrics_collector.id
}
