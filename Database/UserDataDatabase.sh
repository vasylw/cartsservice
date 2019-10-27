MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="
--==MYBOUNDARY==
Content-Type: text/cloud-config; charset="us-ascii"

runcmd:
- sudo apt -y update
- sudo apt -y install openjdk-8-jdk
- sudo apt -y update
- wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
- sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
- sudo apt -y update
- sudo apt-get -y install -y mongodb-org
- sudo ufw allow 27017
- sudo service mongod start

--==MYBOUNDARY==--