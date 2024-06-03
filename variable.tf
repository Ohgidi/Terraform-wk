variable "network_interface_id" {

  type = string

  default = "network_id_from_aws"

}

variable "ami" {

    type = string

    default = "ami-06373f703eb245f45"

}

variable "instance_type" {

    type = string

    default = "t2.micro"

}