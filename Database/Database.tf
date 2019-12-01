
resource "aws_instance"  "database" {
    ami = var.image_id
    availability_zone = var.availability_zone   
        
    root_block_device {
      volume_size = "10"
    }
    
        
    instance_type = var.instance_type

    key_name = "EC2_Linux_CI_Server"

    user_data = "TUlNRS1WZXJzaW9uOiAxLjAKQ29udGVudC1UeXBlOiBtdWx0aXBhcnQvbWl4ZWQ7IGJvdW5kYXJ5PSI9PU1ZQk9VTkRBUlk9PSIKLS09PU1ZQk9VTkRBUlk9PQpDb250ZW50LVR5cGU6IHRleHQvY2xvdWQtY29uZmlnOyBjaGFyc2V0PSJ1cy1hc2NpaSIKCnJ1bmNtZDoKLSBzdWRvIGFwdCAteSB1cGRhdGUKLSBzdWRvIGFwdCAteSBpbnN0YWxsIG9wZW5qZGstOC1qZGsKLSBzdWRvIGFwdCAteSB1cGRhdGUKLSBzdWRvIHVmdyBhbGxvdyAyNzAxNwotIHN1ZG8gdWZ3IGFsbG93IDMzMDYKCi0tPT1NWUJPVU5EQVJZPT0tLQ=="

    monitoring  = "false"

    disable_api_termination = false

    instance_initiated_shutdown_behavior = "stop"

    vpc_security_group_ids = [var.sg_db_id]

    tags = { Name = var.instance_name }
    
          
provisioner "local-exec" {
    command = "echo ${aws_instance.database.private_ip} > private_ip_database.txt"
    
  }

provisioner "local-exec" {
    command = "echo carts-db  ${aws_instance.database.private_ip} >> ./etc/hosts"
    
  }
    
provisioner "local-exec" {
    command = "echo catalogue-db  ${aws_instance.database.private_ip} >> ./etc/hosts"
    }   

provisioner "local-exec" {
    command = "echo [database_server] >> hosts"
    
  }
    

provisioner "local-exec" {
    command = "echo '${aws_instance.database.private_ip} ansible_user=ubuntu ansible_connection=ssh ansible_private_key_file=/var/lib/jenkins/EC2_Linux_CI_server' >> hosts"
    
  }

}
