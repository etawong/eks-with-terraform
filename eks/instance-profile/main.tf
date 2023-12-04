# Declaring the AWS provider
provider "aws" {
  region = "us-west-2"
}

# Role
resource "aws_iam_role" "instance_role" {
  name = "my_test_role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = aws_iam_role.instance_role.name
}

resource "aws_iam_policy" "policy" {
  name        = "iam-policy-for-instance-role"
  description = "iam-policy-for-instance-role"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
              "s3:Get*", "ec2:*", "SNS:List*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]    
}
EOF
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.instance_role.name
  policy_arn = aws_iam_policy.policy.arn
}

/*
resource "aws_s3_bucket" "bucket" {
  bucket = "my-s3-bucket-99999"

  tags = {
    name = "My bucket"
    Environment = "Dev"
  }
}
*/

data "aws_ami" "amzLinux2" {
  most_recent = true       # boolean variable
  owners      = ["amazon"] # Or you can put the owner account ID (137112412989)

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
    # The original images is (amzn2-ami-kernel-5.10-hvm-2.0.20230822.0-x86_64-gp2)
    # The * represents the values that change when the AMI is updated.
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
resource "aws_instance" "web" {
  ami                  = data.aws_ami.amzLinux2.id
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.test_profile.id
  key_name             = "terraform"

  tags = {
    Name = "Test_instance_profile"
  }
}
