data "aws_availability_zones" "metrics_collector" {
  state = "available"
}
resource "aws_ebs_volume" "metrics_" {
  availability_zone = var.metrics_collector_availability_zone
  size              = 10

  tags = {
      Name                = "Metrics collector Persistent Storage"
      TerraformWorkspace  = terraform.workspace
      TerraformModule     = basename(abspath(path.module))
      TerraformRootModule = basename(abspath(path.root))
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.metrics_collector.id
  instance_id = aws_instance.metrics_collector.id
 }

resource "aws_instance" "metrics_collector" {
  ami                     =   data.aws_ami.fedora_coreos.id
  instance_type           =   var.instance_type
  availability_zone       =   var.metrics_collector_availability_zone

  root_block_device {
    volume_size           = 25
    delete_on_termination = true
  }

  vpc_security_group_ids  = [aws_security_group.metrics_collector.id]
  source_dest_check       = false

  tags = {
    Name                  = "${var.module_name}"
    TerraformWorkspace    = terraform.workspace
    TerraformModule       = basename(abspath(path.module))
    TerraformRootModule   = basename(abspath(path.root))
  }

  user_data               = base64encode(data.ct_config.metrics_collector.rendered)

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [vpc_security_group_ids, security_groups]
  }

  iam_instance_profile = aws_iam_instance_profile.metrics_collector.name
}

