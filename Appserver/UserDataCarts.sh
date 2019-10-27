MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="
--==MYBOUNDARY==
Content-Type: text/cloud-config; charset="us-ascii"

runcmd:
- sudo apt -y update
- sudo apt -y install openjdk-8-jdk
- sudo ufw allow 8081

--==MYBOUNDARY==--