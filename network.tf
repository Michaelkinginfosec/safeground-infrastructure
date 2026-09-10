
resource "aws_vpc" "safeground_aws_vpc"{
    cidr_block = "10.0.0.0/20"

    tags = {
      Name = "safeground-vpc"
    }
}


resource "aws_subnet" "safeground_aws_public_subnet"{
    vpc_id = aws_vpc.safeground_aws_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-north-1a"

    tags = {
        Name = "safeground-public-subnet"
    }
}



resource "aws_internet_gateway" "safeground_aws_vpc_ig"{
    vpc_id = aws_vpc.safeground_aws_vpc.id

    tags = {
      Name = "safeground-internet-gateway"
    }
}

# routing table 

resource "aws_route_table" "safeground_aws_rt"{
    vpc_id = aws_vpc.safeground_aws_vpc.id
    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.safeground_aws_vpc_ig.id
    }

    tags = {
      Name = "safeground-route-table"
    }
}

resource "aws_route_table_association" "safeground_aws_rt_association" {
  subnet_id     = aws_subnet.safeground_aws_public_subnet.id
  route_table_id = aws_route_table.safeground_aws_rt.id
}


resource "aws_iam_role" "ecs_instance_role" {
  name = "safeground-ecs-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_policy" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "safeground-ecs-instance-profile"
  role = aws_iam_role.ecs_instance_role.name
}