resource "aws_eks_node_group" "my-node-group" {
  for_each = {for node in var.node-groups : node.name => node}
  cluster_name    = aws_eks_cluster.my-cluster.name
  node_group_name = each.value.name
  node_role_arn   = aws_iam_role.eksNodeRole.arn
  subnet_ids      = [data.aws_subnet.sub1.id, data.aws_subnet.sub2.id]

  scaling_config {
    desired_size = each.value.desired_size
    max_size     = each.value.max_size
    min_size     = each.value.min_size
  }

  update_config {
    max_unavailable = 1
  }

  instance_types = [each.value.instance_type]

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eksNodeRole-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.eksNodeRole-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eksNodeRole-AmazonEKSWorkerNodePolicy,
  ]
}