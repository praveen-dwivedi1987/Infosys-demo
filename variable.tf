variable "cluster_name" {
  default = "my-cluster"
}

variable "node_group_name" {
  default = "my-node-group"
}


variable "node-groups" {
  type = list(map(string))
  default = [{
    name = "my-instance"
    desired_size = 2
    max_size     = 3
    min_size     = 2
    instance_type = "t2.medium"
  },
  {
    name = "my-instance2"
    desired_size = 2
    max_size     = 3
    min_size     = 2
    instance_type = "t2.medium"
  }
  ]
}