resource "aws_instance"  "elk" {
    ami = var.image_id
    availability_zone = var.availability_zone   
        
    root_block_device {
      volume_size = "18"
    }
    
        
    instance_type = var.instance_type

    key_name = "EC2_Linux_CI_Server"

    user_data = "TUlNRS1WZXJzaW9uOiAxLjAKQ29udGVudC1UeXBlOiBtdWx0aXBhcnQvbWl4ZWQ7IGJvdW5kYXJ5PSI9PU1ZQk9VTkRBUlk9PSIKLS09PU1ZQk9VTkRBUlk9PQpDb250ZW50LVR5cGU6IHRleHQvY2xvdWQtY29uZmlnOyBjaGFyc2V0PSJ1cy1hc2NpaSIKCnJ1bmNtZDoKLSBzdWRvIGFwdCAteSB1cGRhdGUKLSBzdWRvIGFwdCAteSBpbnN0YWxsIG9wZW5qZGstOC1qZGsKLSBzdWRvIHVmdyBhbGxvdyAzMzA2Ci0gc3VkbyB1ZncgYWxsb3cgMjcwMTcKLSBzdWRvIHVmdyBhbGxvdyA4MDgwCi0gc3VkbyB1ZncgYWxsb3cgODA3OQotIHN1ZG8gdWZ3IGFsbG93IDgwCi0gc3VkbyB1ZncgYWxsb3cgNDQzCi0gc3VkbyB1ZncgYWxsb3cgODA4MQotIHN1ZG8gdWZ3IGFsbG93IDIyCgotLT09TVlCT1VOREFSWT09LS0="

    monitoring  = "false"

    disable_api_termination = false

    instance_initiated_shutdown_behavior = "stop"

    tags = { Name = var.instance_name }

    vpc_security_group_ids = [var.sg_elk_id]
    
          
provisioner "local-exec" {
    command = "echo ${aws_instance.elk.public_ip} > public_ip_elk_server.txt"
  }


provisioner "local-exec" {
    command = "echo ${aws_instance.elk.private_ip} > private_ip_elk_server.txt"
  }

    
provisioner "local-exec" {
    command = "echo elk  ${aws_instance.elk.private_ip} >> etc_hosts"
    
  }

provisioner "local-exec" {
    command = "echo [elk] >> hosts"
  }

provisioner "local-exec" {
    command = "echo '${aws_instance.elk.private_ip} ansible_user=ubuntu ansible_connection=ssh ansible_private_key_file=/var/lib/jenkins/EC2_Linux_CI_server' >> hosts"
  }

provisioner "local-exec" {
    command = "echo input { tcp {port => 9500}} output { elasticsearch { hosts => ['elasticsearch:9200'] user => elastic  password => changeme  } }     >> /home/logstash.conf"
  }    
  
provisioner "local-exec" {
    command = "echo path.data: /var/lib/elasticsearch   path.logs: /var/log/elasticsearch  node.name: ${HOSTNAME}  network.host: ${ES_NETWORK_HOST}  >> elasticsearch.yml"
  }   

provisioner "local-exec" {
    command = "echo user www-data; worker_processes 4; pid /var/run/nginx.pid; events { worker_connections 768;  # multi_accept on;} >> nginx.conf"
    
 provisioner "local-exec" {
    command = "echo filebeat.inputs: - type: log  enabled: false  paths: - /var/log/*.log   setup.kibana: output.elasticsearch:  hosts: ["localhost:9200"] username: "elastic"  password: "changeme"  processors:- add_host_metadata: ~  - add_cloud_metadata: ~ - add_docker_metadata: ~ - add_kubernetes_metadata: ~  >> filebeat.yml"
  } 
    
    
  }   
    
}
