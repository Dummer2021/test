#----------------------------
# My Terraform
#
# Build WebServer
#
# Copyleft ISA
#----------------------------

provider "aws" {
  region                  = "eu-central-1"
}

resource "aws_instance" "my_Web_Server" {
  ami                     = "ami-05d34d340fb1d89e5"  # Amazon Linux
  instance_type           = "t2.micro"
  vpc_security_group_ids  = [aws_security_group.my_web_server_sg.id]

  tags = {
  Name = "My-Web-Server"
    }

  user_data = <<EOF
#!/bin/bash
yum -y update
yum install -y epel-release
yum install -y nginx
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>MyWebServer with IP: $myip</h2><br>Built by Terraform!" > /usr/share/nginx/html/index.html
echo "<br><font color="green">Hello world ))" >> /usr/share/nginx/html/index.html
sudo systemctl start nginx
chkconfig nginx on
EOF

}

  resource "aws_security_group" "my_web_server_sg" {
    name                 = "WebServer-SG"
    description          = "My-Web-SG"

 ingress {
 description = "All"
 from_port   = 0
 to_port     = 0
 protocol    = "-1"
 cidr_blocks = ["0.0.0.0/0"]
}

    egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]

    }
}
