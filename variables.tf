
# Available regions for instances
# "oregon" = "us-west-2"
#  "virginia" = "us-east-1"
#  "ohio" = "us-east-2"
#  "california" = "us-west-1"
#  "canada" = "ca-central-1"
#  "frankfurt" =	"eu-central-1"
#  "ireland" = "eu-west-1"

variable "uf_region" {
  type = "string"
  default = "oregon"
}

variable "instance_type" {
  type = "string"
  default = "t2.micro"
}

variable "region" {
  type = "map"  
  default = { 
  "oregon" = "us-west-2"
  "virginia" = "us-east-1"
  "ohio" = "us-east-2"
  "california" = "us-west-1"
  "canada" = "ca-central-1"
  "frankfurt" =	"eu-central-1"
  "ireland" = "eu-west-1"
  }
}

variable "azone" {
  type = "map"  
  default = { 
  "frankfurt_a" = "eu-central-1a"
  "frankfurt_b" =	"eu-central-1b"
  "frankfurt_c" =	"eu-central-1c"
  "oregon_a" = "us-west-2a"
  }
}

variable "uf_azone" {
type = "string"
default = "oregon_a"
}


variable "amis" {
  type = "map"
  default = {
      "us-west-1" = "ami-08fd8ae3806f09a08"
      "us-west-2" = "ami-06f2f779464715dc5"
      "us-east-1" = "ami-07d0cf3af28718ef8"
      "us-east-2" = "ami-05c1fa8df71875112"
      "ca-central-1" = "ami-0d0eaed20348a3389"
      "eu-west-1" = "ami-06358f49b5839867c"
      "eu-central-1" = "ami-0ac05733838eabc06"
  }
}

variable "subnet" {
 type = "string"
 default = "172.31.0.0/16"
}

