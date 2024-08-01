variable "cidr_block" {
  type    = string
  default = "172.33.0.0/16"
}

variable "subnet1a_cidr_block_public" {
  type    = string
  default = "172.33.1.0/24"
}

variable "subnet1b_cidr_block_public" {
  type    = string
  default = "172.33.2.0/24"
}

variable "subnet1a_cidr_block_private" {
  type    = string
  default = "172.33.3.0/24"
}

variable "subnet1b_cidr_block_private" {
  type    = string
  default = "172.33.4.0/24"
}

variable "subnet_az_1a" {
  type    = string
  default = "us-east-1a"
}

variable "subnet_az_1b" {
  type    = string
  default = "us-east-1b"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ami" {
  type    = string
  default = "ami-04a81a99f5ec58529"
}