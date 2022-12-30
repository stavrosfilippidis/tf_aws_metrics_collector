variable "module_name" {
  description = "The module name used throughout resources."
  type        = string
  default     = "metrics_collector"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID in which to deploy the metrics collector."
}

variable "subnet_ids" {
  type        =  list(string)
  description = "List of subnet IDs to deploy the metrics collector."
}

variable "ssh_authorized_keys" {
  type        = list(string)
  default     = []
  description = "List of SSH public keys to authorized access on the core user of the Logs collector."
}

# variable "hosted_zone" {
#   type        =  string
#   description = "The route53 hosted zone where records reside in."
# }

# variable "metrics_collector_dns_record" {
#   type        =  string 
#   description = "The route53 dns record used to expose the metrics collector."
# }

variable "ami_id" {
  type        = string
  default     = "fedora-coreos-34.20210626.3.2-x86_64"
  description = "The ami id which makes the choice of operating system for the instance."
}

variable "instance_type" {
  type        = string
  default     = "t3.small"
}

variable "instance_volume_size" {
  type        = number
  default     = 30
}

variable "instance_desired_count" {
  type        = number
  default     = 1 
}

variable "instance_max_count" {
  type        = number
  default     = 1
}

variable "instance_min_count" {
  type        = number
  default     = 1
}

variable "metrics_collector_region" {
  type        = string
  default     = "eu-central-1"
  description = "The aws region from which to scrap the metrics endpoints."
}

variable "metrics_collector_storage_path"{
  type        = string
  default     = "/etc/prometheus/data"
  description = "The prometheus persistency storage location."
}

variable "metrics_collector_availability_zone" {
  type        = string
  default     = "eu-central-1a"
  description = "The metrics collector availability zone in which the instance and the ebs volume will reside."
}

variable "prometheus_container_image" {
  type        = string
  default     = "docker.io/prom/prometheus"
  description = "The prometheus oci image location used for fetching it."
}

variable "blackbox_oci_image" {
  type        = string
  default     = "docker.io/prom/blackbox-exporter:master"
  description = "The blackbox oci image location used for fetching it."
}

variable "blackbox_exporter_port" {
  type        = number
  default     = 9115
  description = "Port where the blackbox exporter is exposing it's information."
}

variable "sample_port" {
  type        = number
  default     = 9100
  description = "The port used to scrap node exporter metrics."
}

variable "blackbox_targets" {
  type = list(object({
    domain    = string
  }))
  default     = []
  description = "List of blackbox targets used to probe endpoints over HTTP, HTTPS, DNS, TCP, ICMP, gRPC."
}

variable "prometheus_aws_jobs" {
  type = list(object({
    name             = string
    region           = string
    port             = string
    metrics_path     = string 
    metrics_tag_key  = string
    use_format_params = string
  }))
  default     = []
  description = "List of prometheus endpoint configuration used in targeting and scrapping metrics."
}

variable "reverse_proxy_image" {
  type        = string
  default     = "docker.io/library/nginx"
  description = "The nginx oci image location used for fetching it."
}