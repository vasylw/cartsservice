
resource "aws_instance"  "carts_app" {
    ami = var.image_id
    availability_zone = var.availability_zone   
        
    root_block_device {
      volume_size = "10"
    }
    
        
    instance_type = var.instance_type

    key_name = "EC2_Linux_CI_Server"

    user_data = "TUlNRS1WZXJzaW9uOiAxLjAKQ29udGVudC1UeXBlOiBtdWx0aXBhcnQvbWl4ZWQ7IGJvdW5kYXJ5PSI9PU1ZQk9VTkRBUlk9PSIKLS09PU1ZQk9VTkRBUlk9PQpDb250ZW50LVR5cGU6IHRleHQvY2xvdWQtY29uZmlnOyBjaGFyc2V0PSJ1cy1hc2NpaSIKCnJ1bmNtZDoKLSBzdWRvIGFwdCAteSB1cGRhdGUKLSBzdWRvIGFwdCAteSBpbnN0YWxsIG9wZW5qZGstOC1qZGsKLSBzdWRvIHVmdyBhbGxvdyA4MDgxCgotLT09TVlCT1VOREFSWT09LS0="

    monitoring  = "false"

    disable_api_termination = false

    instance_initiated_shutdown_behavior = "stop"

    tags = { Name = var.instance_name }

    vpc_security_group_ids = [var.sg_carts_id]
    
          
provisioner "local-exec" {
    command = "echo ${aws_instance.carts_app.public_ip} > public_ip_carts_app_server.txt"
  }


provisioner "local-exec" {
    command = "echo ${aws_instance.carts_app.private_ip} > private_ip_carts_app_server.txt"
  }

}