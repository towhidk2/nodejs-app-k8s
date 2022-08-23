# variables
variable vpc_cidr_block {
    default = "10.0.0.0/16"
}
variable subnet_1_cidr_block {
    default = "10.0.1.0/24"
}
variable avail_zone {
    default = "us-east-1a"
}
variable env_prefix {
    default = "dev"
}
variable my_office_ip {
    default = "61.247.183.179/32"
}
variable my_home_ip {
    default = "0.0.0.0/0"
}
variable instance_type {
    default = "t2.micro"
}
variable ssh_public_key {
    default = "/home/towhid/.ssh/id_rsa.pub"
}

variable "instance_count" {
    default = "1"
}

# variable "instance_tags" {
#   type = list
#   default = ["dev-server"]
# }

# variable "us_east_1_ami_id" {
#   default = "ami-0cff7528ff583bf9a"
# }