data "aws_vpc" "my-vpc" {
  default = true
}

data "aws_subnet" "sub1" {
  vpc_id            = data.aws_vpc.my-vpc.id
  availability_zone = "us-east-1a"
}

data "aws_subnet" "sub2" {
  vpc_id            = data.aws_vpc.my-vpc.id
  availability_zone = "us-east-1b"
}