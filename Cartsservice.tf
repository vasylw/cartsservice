# Cloud provider setting
provider "aws" {
  shared_credentials_file = "/var/lib/jenkins/workspace/.aws/credentials"
  region     = var.region[var.uf_region]
  profile = "default"
}


# Create a AWS instance for Application server, using module
module "carts_app" {
  source      = "./Appserver"
  availability_zone     = var.azone[var.uf_azone]
  image_id = var.amis[var.region[var.uf_region]]
  instance_name = "carts"
  instance_type = var.instance_type
  sg_carts_id = aws_security_group.carts_sg.id
}


# Create a AWS instance for database server, using module
module "database" {
  source      = "./Database"
  availability_zone     = var.azone[var.uf_azone]
  image_id = var.amis[var.region[var.uf_region]]
  instance_name = "database"
  instance_type = var.instance_type
  sg_db_id = aws_security_group.database_sg.id
}

  # Create a AWS instance for database server, using module
module "elk" {
  source      = "./ELK"
  availability_zone     = var.azone[var.uf_azone]
  image_id = var.amis[var.region[var.uf_region]]
  instance_name = "elk"
  instance_type = "t2.xlarge"
  sg_elk_id = aws_security_group.elk_sg.id
}
