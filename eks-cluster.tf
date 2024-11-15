resource "aws_eks_cluster" "my-cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eksClusterRole.arn

  vpc_config {
    subnet_ids = [data.aws_subnet.sub1.id, data.aws_subnet.sub2.id]
  }


  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  
  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks-policy-attach-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-policy-attach-AmazonEKSVPCResourceController,
  ]
}

output "endpoint" {
  value = aws_eks_cluster.my-cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.my-cluster.certificate_authority[0].data
}

output "open-id-connect-details" {
  value = aws_eks_cluster.my-cluster.identity[0].oidc[0].issuer
}