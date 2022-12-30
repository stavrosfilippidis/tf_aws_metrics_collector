variable "ssh_authorized_keys" {
  type        = list(string)
  default     = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCiXT2UHq+pTQnRqGOD0Em+DirSDRVgJ2Uw3wy74NThFokMNISPtv+WeFyY1s6M7F0dPd5kksNyRUhl446lb0hcC5W43LuBE4NxSuM/VeHlnehwSw8mnoKuHeSdK/53bA+x0ZAtt2VwvSOJyMkTDA5a6gEgs8A7YmC6DPbjfXR9uydSjh0SUsDDZKZ0Hv8yz1FEnDm9oA+ZpwRAcdTLIny+aBl4ll6RuMXbwcbyUniu9eXOl9Tb3gTu2sWpzLTorAsz9Kupbha9UGPN8SrQ6p0Xx4YCZZ4P7yX+upvoKDW9A962DI58u+IMoQ9zJbOhGKkSzIv7oL9G51Gs64ib15KCzuQ4LAvj30sEmZhI18mXZjyCarybJPo1Cp4iM90zT+H9cj2XTQH92bgK5PhCB2ZGxziYJB7HONbvmtfTuwbAbgtbGOv5OOw+Vxde8gjWJgSLIU4BLjxrZB/t6575icqSTtj/LzCYmmsWU7xD/FTRJtminbpX4YasXrbvQqe65b0= stavros@fedora"]
  description = "List of SSH public keys to authorized access on the fedora user for the metrics aggregator."
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
    name              = string
    region            = string
    port              = string
    metrics_path      = string  
    metrics_tag_key   = string
    use_format_params = string
  }))
  default     = []
  description = "List of prometheus aws jobs for metrics scrapping."
}


