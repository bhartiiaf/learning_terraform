resource "aws_instance" "prometheus_grafana" {
  ami                    = "ami-026ebd4cfe2c043b2"
  instance_type          = "t2.micro"
  key_name               = "tigi"
  vpc_security_group_ids = [aws_security_group.promethus_sg.id]
  #user_data              = file("${path.module}/user_data.sh")

  tags = {
    Name = "prometheus-grafana-instance"
  }
}

resource "aws_instance" "prometheus_exporter" {
  ami                    = "ami-026ebd4cfe2c043b2"
  instance_type          = "t2.micro"
  key_name               = "tigi"
  vpc_security_group_ids = [aws_security_group.promethus_sg.id]
  user_data              = file("${path.module}/exporter.sh")

  tags = {
    Name = "prometheus-exporter-instance"
  }
}

resource "aws_security_group" "promethus_sg" {
  name_prefix = "promethus_sg"
  description = "security group for Promethus and Grafana"

  // Inbound rules (ingress)
  ## For Promethus
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic from any IP (for demonstration purposes)
  }

  ## For Graphana
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic from any IP (for demonstration purposes)
  }
  ## For Exporter
  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic from any IP (for demonstration purposes)
  }

  ## For SSh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic from any IP (for demonstration purposes)
  }

  // Outbound rules (egress)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}