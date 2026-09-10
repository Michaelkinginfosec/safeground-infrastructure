output "ec2_public_ip" {
  value = aws_eip.safeground_aws_eip.public_ip
}

output "ecr_repository_url" {
  value = aws_ecr_repository.safeground_app.repository_url
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.safeground_cluster.name
}
output "ecr_repository_arn" {
  value = aws_ecr_repository.safeground_app.arn
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.safeground_cluster.arn
}