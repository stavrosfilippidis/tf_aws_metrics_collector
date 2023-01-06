terraform {
    required_providers {
        ct = {
            source = "poseidon/ct"
            version = "0.11.0"
        } 
    }
}

data "aws_vpc" "default" {
  default = true
}
