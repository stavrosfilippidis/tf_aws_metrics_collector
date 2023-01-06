
resource "aws_security_group_rule" "https_egress" {
  type                     = "egress"
  description              = "Used for connecting to internet resources over https."
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"] 
  security_group_id        = module.metrics_aggregator_cluster.metrics_collector_security_group_id
}

resource "aws_security_group_rule" "http_egress" {
  type                     = "egress"
  description              = "Used for connecting to internet resources over http."
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"] 
  security_group_id        = module.metrics_aggregator_cluster.metrics_collector_security_group_id
}

resource "aws_security_group_rule" "dns_connectivity" {
  type                     = "egress"
  description              = "Used for resolving hostnames over DNS."
  from_port                = 53
  to_port                  = 53
  protocol                 = "udp"
  cidr_blocks              = [data.aws_vpc.default.cidr_block]  
  security_group_id        = module.metrics_aggregator_cluster.metrics_collector_security_group_id
}

resource "aws_security_group_rule" "dns_connectivity_fallback" {
  type                     = "egress"
  description              = "Used for resolving hostnames over DNS."
  from_port                = 53
  to_port                  = 53
  protocol                 = "tcp"
  cidr_blocks              = [data.aws_vpc.default.cidr_block] 
  security_group_id        = module.metrics_aggregator_cluster.metrics_collector_security_group_id
}

resource "aws_security_group_rule" "node_exporter_egress" {
  type                     = "egress"
  description              = "Used for grabbing node exporter metrics from other machines."
  from_port                = 9100
  to_port                  = 9100
  protocol                 = "tcp"
  cidr_blocks              = [data.aws_vpc.default.cidr_block] 
  security_group_id        = module.metrics_aggregator_cluster.metrics_collector_security_group_id
}
