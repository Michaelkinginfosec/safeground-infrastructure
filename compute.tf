
resource "aws_instance" "safeground_ec2_instance" {
    ami  = "ami-0aba19e56f3eaec05"
    instance_type = "t3.small"
    key_name = "demo-aws-keys"
    iam_instance_profile = aws_iam_instance_profile.ecs_instance_profile.name
    subnet_id = aws_subnet.safeground_aws_public_subnet.id
    vpc_security_group_ids = [aws_security_group.safeground_aws_sg.id]


    user_data_replace_on_change = true

    
    user_data = <<-EOF
        #!/bin/bash
        apt update -y
        apt upgrade -y
        apt install -y nginx docker.io
        systemctl start nginx
        systemctl enable nginx
        systemctl start docker
        systemctl enable docker

        mkdir -p /etc/ecs
        echo ECS_CLUSTER=${aws_ecs_cluster.safeground_cluster.name} | tee -a /etc/ecs/ecs.config

        docker run --name ecs-agent \
          --detach=true \
          --restart=on-failure:10 \
          --volume=/var/run:/var/run \
          --volume=/var/log/ecs/:/log \
          --volume=/var/lib/ecs/data:/data \
          --volume=/etc/ecs:/etc/ecs \
          --net=host \
          --env-file=/etc/ecs/ecs.config \
          amazon/amazon-ecs-agent:latest
        EOF

    tags = {
        Name = "safeground-instance"
    }
}
resource "aws_eip" "safeground_aws_eip" {
  domain = "vpc"

  tags = {
    Name = "safeground-eip"
  }
}

resource "aws_eip_association" "safeground_eip_association" {
  instance_id   = aws_instance.safeground_ec2_instance.id
  allocation_id = aws_eip.safeground_aws_eip.id
}

resource "aws_ecs_cluster" "safeground_cluster" {
  name = "safeground-cluster"

  tags = {
    Name = "safeground-cluster"
  }
}