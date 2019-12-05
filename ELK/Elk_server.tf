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
    command = "echo input { tcp {port => 9500}} output { elasticsearch { hosts => ["elasticsearch:9200"] user => elastic  password => changeme  } }     >> /home/logstash.conf"
  }    
  
provisioner "local-exec" {
    command = "echo path.data: /var/lib/elasticsearch   path.logs: /var/log/elasticsearch  node.name: ${HOSTNAME}  network.host: ${ES_NETWORK_HOST}  >> elasticsearch.yml"
  }   

provisioner "local-exec" {
    command = "echo user www-data;
worker_processes 4;
pid /var/run/nginx.pid;

events {
  worker_connections 768;
  # multi_accept on;
}

http {

  ##
  # Basic Settings
  ##

  sendfile on;
  tcp_nopush on;
  tcp_nodelay on;
  keepalive_timeout 65;
  types_hash_max_size 2048;
  large_client_header_buffers 6 32k;
  client_max_body_size 100m;

  # server_names_hash_bucket_size 64;
  # server_name_in_redirect off;
  include /etc/nginx/mime.types;
  default_type application/octet-stream;

  ##
  # Logging Settings
  ##
  access_log /var/log/nginx/access.log;
  error_log /var/log/nginx/error.log debug; # change from debug to warn or error for production

  ##
  # Gzip Settings
  ##
  gzip on;
  gzip_disable "msie6";

  ##
  # Virtual Host Configs
  ##

  include /etc/nginx/conf.d/*.conf;
  include /etc/nginx/sites-enabled/*;

  server {
    listen                     443;
    ssl                        on;
    ssl_certificate            /etc/looker/ssl/certs/self-ssl.crt;
                                 # replace with your cert file
    ssl_certificate_key        /etc/looker/ssl/private/self-ssl.key;
                                 # replace with your key file
    ssl_protocols              TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers                RC4:HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers  on;
    ssl_session_cache          shared:SSL:10m;
    ssl_session_timeout        10m;

    location / {
      proxy_pass https://looker.domain.com:9999; # Replace looker.domain.com with the name
                                                 # that clients will use to access Looker

      ### Force timeouts if one of backend hosts is dead ###
      proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;

      ### Set headers ###
      proxy_set_header          X-Real-IP $remote_addr;
      proxy_set_header          Accept-Encoding "";
      proxy_set_header          Host $http_host;
      proxy_set_header          X-Forwarded-For $proxy_add_x_forwarded_for;

      ### Don't timeout waiting for long queries - timeout is 1 hr ###
      proxy_read_timeout        3600;
      proxy_set_header          X-Forwarded-Proto $scheme;

      ### By default we don't want to redirect ###
      proxy_redirect            off;

      proxy_buffer_size         128k;
      proxy_buffers             4 256k;
      proxy_busy_buffers_size   256k;
    }
  }

  server {
    listen                     19999;
    ssl                        on;
    ssl_certificate            /etc/looker/ssl/certs/self-ssl.crt;
                                 # replace with your cert file
    ssl_certificate_key        /etc/looker/ssl/private/self-ssl.key;
                                 # replace with your key file
    ssl_protocols              TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers                RC4:HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers  on;
    ssl_session_cache          shared:SSL:10m;
    ssl_session_timeout        10m;

    location / {
      proxy_pass https://looker.domain.com:19999; # Replace looker.domain.com with the name
                                                  # that clients will use to access Looker

      ### Force timeouts if one of backend hosts is dead ###
      proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;

      ### Set headers ###
      proxy_set_header          X-Real-IP $remote_addr;
      proxy_set_header          Accept-Encoding "";
      proxy_set_header          Host $http_host;
      proxy_set_header          X-Forwarded-For $proxy_add_x_forwarded_for;

      ### Don't timeout waiting for long queries - timeout is 1 hr ###
      proxy_read_timeout        3600;
      proxy_set_header          X-Forwarded-Proto $scheme;

      ### By default we don't want to redirect ###
      proxy_redirect            off;

      proxy_buffer_size         128k;
      proxy_buffers             4 256k;
      proxy_busy_buffers_size   256k;
    }
  }
} >> nginx.conf"
    
 provisioner "local-exec" {
    command = "echo filebeat.inputs:


- type: log

  # Change to true to enable this input configuration.
  enabled: false

  # Paths that should be crawled and fetched. Glob based paths.
  paths:
    - /var/log/*.log
#============================= Filebeat modules ===============================

filebeat.config.modules:
  # Glob pattern for configuration loading
  path: ${path.config}/modules.d/*.yml

  # Set to true to enable config reloading
  reload.enabled: false

  # Period on which files under path should be checked for changes
  #reload.period: 10s

#==================== Elasticsearch template setting ==========================

setup.template.settings:
  index.number_of_shards: 1
  #index.codec: best_compression
  #_source.enabled: false

#============================== Kibana =====================================

# Starting with Beats version 6.0.0, the dashboards are loaded via the Kibana API.
# This requires a Kibana endpoint configuration.
setup.kibana:

output.elasticsearch:
  # Array of hosts to connect to.
  hosts: ["localhost:9200"]

  # Protocol - either `http` (default) or `https`.
  #protocol: "https"

  # Authentication credentials - either API key or username/password.
  #api_key: "id:api_key"
  #username: "elastic"
  #password: "changeme"

processors:
  - add_host_metadata: ~
  - add_cloud_metadata: ~
  - add_docker_metadata: ~
  - add_kubernetes_metadata: ~

  >> filebeat.yml"
  } 
    
    
  }   
    
}
