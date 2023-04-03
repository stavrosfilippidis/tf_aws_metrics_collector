locals {
  ignition_metrics_collector = <<EOF
variant: fcos
version: 1.4.0
passwd:
  users:
    - name: core
      groups:
        - wheel
      ssh_authorized_keys:
          - ${var.authorized_key}
    - name: prometheus
      shell: /usr/sbin/nologin
systemd:
  units:
    - name: 'node-exporter.service' 
      enabled: yes 
      contents: | 
        [Unit]
        Description=Node exporter 
        After=network-online.target
        Wants=network-online.target
        StartLimitInterval=60
        StartLimitIntervalSec=60
        StartLimitBurst=3

        [Service]
        Logs_Directory=node_exporter
        TimeoutStartSec=0
        ExecStartPre=/usr/bin/podman pull ${var.node_exporter_image_name}
        ExecStart=/usr/bin/podman run --rm --net="host" --pid="host" -v "/:/host:ro,rslave" ${var.node_exporter_image_name} --path.rootfs=/host
        User=core
        Group=core 
        Restart=always
        RestartSec=1min 
        Restart=on-failure
        RestartSec=5
        TimeoutStopSec=30

        [Install]
        WantedBy=multi-user.target  

    - name: 'blackbox-exporter.service'
      enabled: yes
      contents: |
        [Unit]
        Description=Prometheus Metrics Server
        After=network-online.target
        Wants=network-online.target
        [Service]
        TimeoutStartSec=0
        ExecStartPre=/usr/bin/podman pull docker.io/prom/prometheus
        ExecStart=/usr/bin/podman run --rm -p ${var.blackbox_exporter_port}:${var.blackbox_exporter_port} --name blackbox_exporter -v /etc/blackbox-exporter/:/config ${var.blackbox_oci_image} --config.file=/config/blackbox.yml
        User=core
        Group=core
        Restart=always
        RestartSec=1min
        [Install]
        WantedBy=multi-user.target

    - name: 'prometheus.service'
      enabled: yes
      contents: |
        [Unit]
        Description=Prometheus Metrics Collector Server
        After=network-online.target
        Wants=network-online.target
        [Service]
        TimeoutStartSec=0
        ExecStartPre=/bin/sleep 5
        ExecStartPre=/usr/bin/podman pull docker.io/prom/prometheus
        ExecStart=/usr/bin/podman run --log-driver journald --net="host" --pid="host" -v ${var.metrics_collector_storage_path}:/storage -v /etc/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml ${var.prometheus_container_image} --config.file /etc/prometheus/prometheus.yml --storage.tsdb.path /storage
        User=core
        Group=core
        Restart=always
        RestartSec=1min
        [Install]
        WantedBy=multi-user.target
storage:
  directories:
    - path: /etc/prometheus
      mode: 0777
      user:
        name: core
      group:
        name: core

    - path: /etc/blackbox-exporter
      mode: 0755
      user:
        name: core
      group:
        name: core

    - path: ${var.metrics_collector_storage_path}
      mode: 0777
      user:
        name: core
      group:
        name: core
  filesystems:
    - path:  ${var.metrics_collector_storage_path}
      device: /dev/nvme1n1
      format: ext4
      with_mount_unit: true
  files:
    - path: /etc/zincati/config.d/90-disable-auto-updates.toml
      mode: 0644
      user:
        name: root
      group:
        name: root
      contents:
        inline: |
          [updates]
          enabled = false

    - path: /etc/blackbox-exporter/blackbox.yml
      mode: 0755
      user:
        name: core
      group:
        name: core
      contents:
        inline: |
            modules:
              sample_webservice:
                prober: http
                timeout: 15s
                http:
                  method: GET
                  fail_if_body_matches_regexp:
                    - "nginx"
                  valid_status_codes: [200, 201, 302, 304]

    - path: /etc/prometheus/prometheus.yml
      mode: 0644
      user:
        name: prometheus
      group:
        name: prometheus
      contents:
        inline: |
          global:
            scrape_interval:     5s
            evaluation_interval: 15s
          rule_files:
              - 'prometheus.rules.yml'
          scrape_configs:
              - job_name: 'prometheus'
                static_configs:
                - targets: ['localhost:9090']
            
              - job_name: 'blackbox'
                metrics_path: /probe
                params:
                  module: ['sample_webservice']  # Look for a HTTP 200 response.
                static_configs:
                  - targets:
                      %{for target in var.blackbox_targets}
                       - ${target.domain} 
                      %{endfor~}
                relabel_configs:
                  - source_labels: [__address__]
                    target_label: __param_target
                  - source_labels: [__param_target]
                    target_label: instance
                  - target_label: __address__
                    replacement: localhost:${var.blackbox_exporter_port}

            %{for job in var.prometheus_aws_jobs}
              - job_name: ${job.name}
                scheme: http
                metrics_path: ${job.metrics_path}
                %{if (job.use_format_params == "prometheus") }
                params:
                  format: ['prometheus'] %{endif}
                ec2_sd_configs:
                    - region:   ${job.region}
                      port:     ${job.port}
                relabel_configs:
                   - source_labels: [__meta_ec2_tag_Name]
                     target_label: name
                   - source_labels:  [__meta_ec2_public_ip]
                     target_label: public_ip
                   - source_labels:  [__meta_ec2_private_ip]
                     target_label: private_ip
              %{endfor~}
EOF
}

data "ct_config" "metrics_collector" {
  strict       = true
  pretty_print = false

  content = local.ignition_metrics_collector
}





