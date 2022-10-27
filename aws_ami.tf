data "aws_ami" "fedora_core_os" {
    most_recent = true 
    owners = ["125523088429"]

    filter {
        name = "name" 
        values = [var.ami_id]
    }
}