resource "aws_db_instance" "rds1" {
  allocated_storage      = 10
  db_name                = "mydb"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = "admin123"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.allow_tls_private.id]
  availability_zone      = "us-east-1a"
  db_subnet_group_name = aws_db_subnet_group.dbgroup1.id
}

resource "aws_db_subnet_group" "dbgroup1" {
  name       = "main"
  subnet_ids = [aws_subnet.private1a.id, aws_subnet.private1b.id]

  tags = {
    Name = "MyDB-subnet-group"
  }
}

