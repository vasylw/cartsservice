# Cloud provider setting
provider "aws" {
  shared_credentials_file = "/var/lib/jenkins/workspace/.aws/credentials"
  region     = var.region[var.uf_region]
  profile = "default"
}

# Create security grops for Application_server and database

resource "aws_security_group" "carts_sg" {
  name        = "carts_sg"
  description = "Allow 22_8081 port inbound traffic"

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all_to_carts"
  }
}

resource "aws_security_group" "database_sg" {
  name        = "database_sg"
  description = "Allow 22_27017 port inbound traffic"

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = [var.subnet]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.subnet]
  }

  tags = {
    Name = "allow_local_to_database"
  }
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

