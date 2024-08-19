resource "aws_security_group" "web_sg" {
  name        = "allow_web_traffic"
  description = "Allow inbound web traffic"

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app" {
  ami           = "ami-0c55b159cbfafe1f0" 
  instance_type = "t2.micro"
  key_name      = var.key_name 

  security_groups = [aws_security_group.web_sg.name]

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install docker.io -y
    sudo systemctl start docker
    sudo systemctl enable docker

    docker run -d -p 3000:3000 your-docker-image:latest # Replace with your Docker image
  EOF

  tags = {
    Name = "nx-app-instance"
  }
}
