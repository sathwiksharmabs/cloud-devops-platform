resource "aws_db_subnet_group" "app" {
  name       = "${var.environment}-app-db-subnets"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name        = "${var.environment}-app-db-subnets"
    Environment = var.environment
  }
}

resource "aws_security_group" "rds" {
  name        = "${var.environment}-app-rds-sg"
  description = "Allow PostgreSQL only from EKS workloads"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "PostgreSQL from EKS"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = ["sg-0a1172e8d98a14792"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-app-rds-sg"
    Environment = var.environment
  }
}

resource "aws_db_instance" "app" {
  identifier                  = "${var.environment}-cloud-devops-db"
  engine                      = "postgres"
  instance_class              = "db.t3.micro"
  allocated_storage           = 20
  max_allocated_storage       = 20
  storage_type                = "gp3"
  db_name                     = "clouddevops"
  username                    = "appadmin"
  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.app.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false
  multi_az               = false

  backup_retention_period = 1
  deletion_protection     = false
  skip_final_snapshot     = true

  tags = {
    Name        = "${var.environment}-cloud-devops-db"
    Environment = var.environment
  }
}
