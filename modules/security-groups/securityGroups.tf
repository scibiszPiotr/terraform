resource "aws_security_group" "pscibisz-ssh-allowed-public" {
  vpc_id = var.vpc_id

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "pscibisz-ssh-allowed-public"
  }
}

resource "aws_security_group" "pscibisz-http-allowed-public" {
  vpc_id = var.vpc_id

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "pscibisz-http-allowed-public"
  }
}

resource "aws_security_group" "pscibisz-mysql-allowed-private" {
  vpc_id = var.vpc_id

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  tags = {
    Name = "pscibisz-mysql-allowed-private"
  }
}
