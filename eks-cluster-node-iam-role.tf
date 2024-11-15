resource "aws_iam_role" "eksNodeRole" {
  name = "eksNodeRole"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = {
    name = "eks-node-role"
  }
}


resource "aws_iam_role_policy_attachment" "eksNodeRole-AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.eksNodeRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eksNodeRole-AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.eksNodeRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "eksNodeRole-AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.eksNodeRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}