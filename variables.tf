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
  description = "List of SSH public keys to authorized access on the core user of the Logs collector."
  type        = list(string)
  default     = []
}

variable "s3_bucket_fedora_core_os_base_arn" {
  description = "The arn used in configuring access policies on the AWS S3 bucket."
  type        = string
}

variable "fedora_core_config_path" {
  type        = string
  description = "The url which points to the fedora base config on s3. In there are is the shared basic configuration."
}

variable "hosted_zone" {
  description = "The route53 hosted zone where records reside in."
  type        =  string 
}

variable "metrics_collector_dns_record" {
  description = "The route53 dns record for the metrics collector."
  type        =  string 
}

variable "ami_id" {
  description = "The ami id which the operating system to use."
  type        = string
  default     = "fedora-coreos-34.20210626.3.2-x86_64"
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
  description = "The region from which to scrap all the metrics."
  type        = string
  default     = "eu-central-1"
}

variable "metrics_collector_storage_path"{
  description = "The prometheus persistens storage location."
  type        = string
  default     = "/etc/prometheus/data"
}

variable "metrics_collector_availability_zone" {
  description = "The metrics collector availability zone in which the instance and the ebs volume reside."
  type        = string
  default     = "eu-central-1a"
}

variable "prometheus_container_image" {
  description = "The prometheus server container."
  type        = string
  default     = "docker.io/prom/prometheus"
}

variable "blackbox_oci_image" {
  description = "The blackbox oci image."
  type        = string
  default     = "docker.io/prom/blackbox-exporter:master"
}

variable "blackbox_exporter_port" {
  description = "Port where the blackbox exporter is exposing it's information."
  type        = number
  default     = 9115
}

variable "blackbox_targets" {
  type = list(object({
    domain    = string
  }))
  default     = []
  description = "List of blackbox_targets."
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
  description = "List of prometheus jobs for metrics collection."
}

variable "reverse_proxy_image" {
  description = "The nginx image to use."
  type        = string
  default     = "docker.io/library/nginx"
}