variable "cluster_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "cluster_version" {
  type    = string
  default = "1.29"
}

variable "node_group_desired_size" {
  type    = number
  default = 2
}

variable "node_group_max_size" {
  type    = number
  default = 3
}

variable "node_group_min_size" {
  type    = number
  default = 1
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "enable_external_dns" {
  type    = bool
  default = false
}