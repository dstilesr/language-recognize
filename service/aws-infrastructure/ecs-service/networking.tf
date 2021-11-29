
resource "aws_security_group" "http_access" {
  name        = "${var.project}-allow-http"
  description = "Allow HTTP traffic."
  ingress {
    from_port        = 80
    protocol         = "tcp"
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    protocol         = "-1"
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name    = "${var.project}-allow-http"
    Project = var.project
  }
}
