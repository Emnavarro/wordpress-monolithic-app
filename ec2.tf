
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


  #Takes the subnet string array from the module
  count = length(module.vpc.public_subnets)
}


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