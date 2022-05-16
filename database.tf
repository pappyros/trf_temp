resource "aws_db_subnet_group" "Lohan_db_subnet_group" {
  name       = "lohan_db_subnet_group"
  subnet_ids = [aws_subnet.Lohan_private_DB_1.id,aws_subnet.Lohan_private_DB_2.id]

  tags = {
    Name = "Lohan_DB_subnet_group"
  }
}


resource "aws_db_instance" "Lohan_rds_1" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "lohan_test_db"
  username             = "lohan"
  password             = "abcd123456!"
  port                 = 3306
  db_subnet_group_name = aws_db_subnet_group.Lohan_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.Lohan_rds_sg.id]
  skip_final_snapshot  = true
  # multi_az = var.multi_az
}