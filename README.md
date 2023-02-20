# tf_aws_metrics_collector

This module spawns a server that can be configured to fetch, store and provide metrics. 
It's build using the technologies Fedore Core OS and Prometheus. It's not meant to provide 
a production ready metrics collector server but rather an MVP showcasing the flexibility 
and easiness of configuration.


## What this repo provides 

## Tech stack 

**Prometheus** is an open-source monitoring and alerting toolkit originally developed at SoundCloud. It was created to address the need for a scalable monitoring solution that could handle the high-dimensional data required to monitor modern, microservices-based architectures.  

Prometheus collects metrics from targets (services, applications, or systems) by scraping endpoints exposed by the targets. It stores these metrics in a time-series database that allows for querying and analysis of historical data. Prometheus also provides a flexible query language called PromQL that allows for advanced querying and aggregation of metrics.  

Find out more under:  
https://prometheus.io/docs/introduction/overview/   

**Fedora CoreOS** is a minimal, container-focused operating system designed for running containerized workloads securely and at scale. It is a lightweight and streamlined version of Fedora, which is a popular Linux distribution known for its focus on cutting-edge software and open source development.

Find out more under:       
https://docs.fedoraproject.org/en-US/fedora-coreos/  

## Customization 

## Variables 

**Required**  
vpc_id  
subnet_ids  

**Optional**  
module_name  
ami_id  
instance_type  
instance_volume_size  
instance_desired_count  
instance_max_count  
instance_min_count  
metrics_collector_region  
metrics_collector_storage_path   
metrics_collector_availability_zone   
node_exporter_image_name   
prometheus_container_image  
blackbox_oci_image   
blackbox_exporter_port   
blackbox_targets   
prometheus_aws_jobs   
reverse_proxy_image   
authorized_key  




