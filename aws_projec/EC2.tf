resource "aws_instance" "webserver01" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = "Nwest-keypair"
  subnet_id                   = aws_subnet.public1a.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_tls.id]
  user_data                   = base64encode(file("user-data01.sh"))

  tags = {
    name = "Webserver01"
  }
}

resource "aws_instance" "webserver02" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = "Nwest-keypair"
  subnet_id                   = aws_subnet.public1b.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_tls.id]
  user_data                   = base64encode(file("user-data02.sh"))

  tags = {
    name = "Webserver02"
  }
}

resource "aws_instance" "webserver03" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = "Nwest-keypair"
  subnet_id                   = aws_subnet.private1a.id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.allow_tls_private.id]

  tags = {
    name = "Webserver03"
  }
}

resource "aws_instance" "webserver04" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = "Nwest-keypair"
  subnet_id                   = aws_subnet.private1b.id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.allow_tls_private.id]

  tags = {
    name = "Webserver04"
  }
}