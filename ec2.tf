
data "aws_ami" "ec2-ami" {
  most_recent = true 
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

#Create a wordpress module in every availability zone
resource "aws_instance" "wordpress" {
  instance_type = "t2.micro"
  ami =  data.aws_ami.ec2-ami.id
  subnet_id = module.vpc.public_subnets[count.index]
  security_groups = ["${aws_security_group.sg.id}"]
  user_data = "${file("userdata.sh")}"
  iam_instance_profile = aws_iam_instance_profile.ec2-ssm-instanceprofile.name


  #Takes the subnet string array from the module
  count = length(module.vpc.public_subnets)
}

#######################################
#AWS Security wordpress security group#
#######################################

resource "aws_security_group" "sg" {
  vpc_id = module.vpc.vpc_id
  name = "Security group web"
  dynamic "ingress"{
    for_each = var.sg-ports
    content {
        from_port = ingress.value
        to_port = ingress.value
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "-1"
  }
}

variable "sg-ports" {
  type = list(number)
  default = [22,80,443]
}

#IAM Role for Wordpress // Parameter store
resource "aws_iam_role" "ec2-ssm-role" {
  name = "ec2-ssm-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
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

  tags = {
    Name = "Iam role for ssm parameter store"
  }
}
#Attach the policy with the IAM role
resource "aws_iam_role_policy_attachment" "ec2-policy-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role = aws_iam_role.ec2-ssm-role.name
}

#Allows IAM role attachment with an ec2 instance
resource "aws_iam_instance_profile" "ec2-ssm-instanceprofile" {
  name = "ec2-ssm-profile"
  role = aws_iam_role.ec2-ssm-role.name
}

