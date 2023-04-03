resource "aws_iam_policy" "allow_ec2_discovery" {
    name = "${var.module_name}_ec2_describe_${random_string.uid.result}"
    path = "/"
    description = "Grants access for prometheus to scan EC2 machines and find the exporters"

    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
      {
        "Sid":   "ECRRepositoryPolicy",
        "Effect" : "Allow",
        "Action" : [
                    "ec2:Describe*"
                  ], 
        "Resource":  ["*"]
      }
    ]
  })
}

data "aws_iam_policy_document" "allow_ec2" {
  statement {
    actions = ["ec2:Describe*"]
    effect = "Allow"

    resources = [ 
        "*"
    ]
  }
}

resource "aws_iam_role" "metrics_collector" {
  name = "${var.module_name}_${random_string.uid.result}"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "allow_ec2_discovery" {
  role       = aws_iam_role.metrics_collector.name
  policy_arn = aws_iam_policy.allow_ec2_discovery.arn
}

resource "aws_iam_instance_profile" "metrics_collector" {
  name = "${var.module_name}_${random_string.uid.result}"
  role = aws_iam_role.metrics_collector.name
}
