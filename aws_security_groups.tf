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

resource "aws_security_group_rule" "example_egress" {
  type                     = "egress"
  description              = "Used as example for a sample port."
  from_port                = var.sample_port
  to_port                  = var.sample_port 
  protocol                 = "tcp"
  cidr_blocks              = [data.aws_vpc.vpc.cidr_block]
  security_group_id        = aws_security_group.metrics_collector.id
}
