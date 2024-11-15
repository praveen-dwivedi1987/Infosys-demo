terraform {
  backend "s3" {
    bucket = "praveen-dwivedi-infosys-demo-bucket"
    key    = "infosys-demo-eks-cluster.tfstate"
    region = "us-east-1"
  }
}
