data "aws_subnet_ids" "subnets_ids" {
  vpc_id = var.vpc_id
}

data "aws_subnet" "subnets_ids" {
  for_each = data.aws_subnet_ids.subnets_ids.ids
  id       = each.value
}

data "aws_security_group" "vpc-SG" {
  vpc_id = var.vpc_id

  tags = {
    Name = var.sg-to-connect
  }
}

resource "aws_db_subnet_group" "mariadb-sg" {
  name = "pscibisz-mariadb-sg"
  subnet_ids = [for s in data.aws_subnet.subnets_ids : s.id]
}

resource "aws_db_instance" "rds" {
  engine = "mariadb"
  engine_version = "10.5"
  instance_class = "db.t2.micro"
  db_name = var.db-name
  identifier = "pscbisz-mariadb"
  username = var.db-user
  password = var.db-password
  parameter_group_name = "default.mariadb10.5"
  db_subnet_group_name = aws_db_subnet_group.mariadb-sg.name
  vpc_security_group_ids = [data.aws_security_group.vpc-SG.id]
  skip_final_snapshot = true
  allocated_storage = 20
  max_allocated_storage = 1000
}
