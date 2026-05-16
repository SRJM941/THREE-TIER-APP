output "cluster_id" {
  value = aws_eks_cluster.this.id
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_oidc_issuer_url" {
  value = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "node_group_role_arn" {
  value = aws_iam_role.node_group.arn
}

output "alb_controller_role_arn" {
  value = aws_iam_role.alb_controller.arn
}

output "external_dns_role_arn" {
  value = var.enable_external_dns ? aws_iam_role.external_dns.arn : null
}