module "metrics_aggregator_cluster" {
  source = "../../"

  vpc_id                                 = data.aws_vpc.default.id
  subnet_ids                             = tolist(data.aws_subnet_ids.default.ids)
  authorized_key                         = var.authorized_key

  blackbox_targets = concat(var.blackbox_targets, 
    [
      { domain  = "https://hashicorp.com"}, 
      { domain  = "https://www.theverge.com/"}
    ]
  )
  
  prometheus_aws_jobs = concat(var.prometheus_aws_jobs, [
    {
      name   = "node_exporter_metrics"
      region = "eu-central-1"
      port   = "9100"
      metrics_path = "/metrics"  
      metrics_tag_key = "node_exporter_metrics"    
      use_format_params = "default"
    }
  ])
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id

  filter {
    name   = "default-for-az"
    values = [true]
  }
}

resource "random_string" "id" {
  length  = 16
  special = false
  upper   = false
}

