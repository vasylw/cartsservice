
resource "aws_instance"  "database" {
    ami = var.image_id
    availability_zone = var.availability_zone   
        
    root_block_device {
      volume_size = "10"
    }
    
        
    instance_type = var.instance_type

    key_name = "EC2_Linux_CI_Server"

    user_data = "TUlNRS1WZXJzaW9uOiAxLjAKQ29udGVudC1UeXBlOiBtdWx0aXBhcnQvbWl4ZWQ7IGJvdW5kYXJ5PSI9PU1ZQk9VTkRBUlk9PSIKLS09PU1ZQk9VTkRBUlk9PQpDb250ZW50LVR5cGU6IHRleHQvY2xvdWQtY29uZmlnOyBjaGFyc2V0PSJ1cy1hc2NpaSIKCnJ1bmNtZDoKLSBzdWRvIGFwdCAteSB1cGRhdGUKLSBzdWRvIGFwdCAteSBpbnN0YWxsIG9wZW5qZGstOC1qZGsKLSBzdWRvIGFwdCAteSB1cGRhdGUKLSB3Z2V0IC1xTyAtIGh0dHBzOi8vd3d3Lm1vbmdvZGIub3JnL3N0YXRpYy9wZ3Avc2VydmVyLTQuMi5hc2MgfCBzdWRvIGFwdC1rZXkgYWRkIC0KLSBzdWRvIHRlZSAvZXRjL2FwdC9zb3VyY2VzLmxpc3QuZC9tb25nb2RiLW9yZy00LjIubGlzdAotIHN1ZG8gYXB0IC15IHVwZGF0ZQotIHN1ZG8gYXB0LWdldCAteSBpbnN0YWxsIC15IG1vbmdvZGItb3JnCi0gc3VkbyB1ZncgYWxsb3cgMjcwMTcKLSBzdWRvIHNlcnZpY2UgbW9uZ29kIHN0YXJ0CgotLT09TVlCT1VOREFSWT09LS0="

    monitoring  = "false"

    disable_api_termination = false

    instance_initiated_shutdown_behavior = "stop"

    vpc_security_group_ids = [var.sg_db_id]

    tags = { Name = var.instance_name }
    
          
provisioner "local-exec" {
    command = "echo ${aws_instance.database.public_ip} > public_ip_database.txt"
  }


}