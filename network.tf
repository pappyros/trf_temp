

###################################################################
resource "aws_vpc" "Lohan_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
enable_dns_hostnames = true

  tags = {
    Name = "Lohan_vpc"
    user = "s2s_Lohan"
  }
}

resource "aws_subnet" "Lohan_public_1" {
  vpc_id     = aws_vpc.Lohan_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Lohan_public_1"
    user = "s2s_Lohan"
  }
}

resource "aws_subnet" "Lohan_public_2" {
  vpc_id     = aws_vpc.Lohan_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch = true
  tags = {
    Name = "Lohan_public_2"
    user = "s2s_Lohan"
  }
}

resource "aws_subnet" "Lohan_private_1" {
  vpc_id     = aws_vpc.Lohan_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "Lohan_private_1"
    user = "s2s_Lohan"
  }
}

resource "aws_subnet" "Lohan_private_2" {
  vpc_id     = aws_vpc.Lohan_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "Lohan_private_2"
    user = "s2s_Lohan"
  }
}

resource "aws_subnet" "Lohan_private_DB_1" {
  vpc_id     = aws_vpc.Lohan_vpc.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "Lohan_private_DB_1"
    user = "s2s_Lohan"
  }
}

resource "aws_subnet" "Lohan_private_DB_2" {
  vpc_id     = aws_vpc.Lohan_vpc.id
  cidr_block = "10.0.6.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "Lohan_private_DB_2"
    user = "s2s_Lohan"
  }
}



######################################################################################################
resource "aws_eip" "Lohan_nat_ip" {
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_internet_gateway" "Lohan_igw" {
  vpc_id = aws_vpc.Lohan_vpc.id

  tags = {
    Name = "Lohan_igw"
    user = "s2s_Lohan"
  }
}

resource "aws_nat_gateway" "Lohan_nat" {
  allocation_id = aws_eip.Lohan_nat_ip.id
  subnet_id     = aws_subnet.Lohan_public_1.id

  tags = {
    Name = "Lohan_NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.Lohan_igw]
}

######################################################################################################

resource "aws_route_table" "Lohan_public_rt_1" {
  vpc_id = aws_vpc.Lohan_vpc.id

  route {
    cidr_block        = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Lohan_igw.id
  }

  tags = {
    Name = "Lohan_public_rt_1"
    user = "s2s_Lohan"
  }
}

resource "aws_route_table" "Lohan_public_rt_2" {
  vpc_id = aws_vpc.Lohan_vpc.id

  route {
    cidr_block        = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Lohan_igw.id
  }

  tags = {
    Name = "Lohan_public_rt_2"
    user = "s2s_Lohan"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.Lohan_public_1.id
  route_table_id = aws_route_table.Lohan_public_rt_1.id
}
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.Lohan_public_2.id
  route_table_id = aws_route_table.Lohan_public_rt_1.id
}


resource "aws_route_table" "route_table_private_1" {
  vpc_id = aws_vpc.Lohan_vpc.id

  tags = {
    Name = "Lohan-private-rt1"
  }
}

resource "aws_route_table" "route_table_private_2" {
  vpc_id = aws_vpc.Lohan_vpc.id

  tags = {
    Name = "Lohan-private-rt2"
  }
}

resource "aws_route_table_association" "route_table_association_private_1" {
  subnet_id      = aws_subnet.Lohan_private_1.id
  route_table_id = aws_route_table.route_table_private_1.id
}

resource "aws_route_table_association" "route_table_association_private_2" {
  subnet_id      = aws_subnet.Lohan_private_2.id
  route_table_id = aws_route_table.route_table_private_2.id
}

resource "aws_route" "private_nat_1" {
  route_table_id              = aws_route_table.route_table_private_1.id
  destination_cidr_block      = "0.0.0.0/0"
  nat_gateway_id              = aws_nat_gateway.Lohan_nat.id
}

resource "aws_route" "private_nat_2" {
  route_table_id              = aws_route_table.route_table_private_2.id
  destination_cidr_block      = "0.0.0.0/0"
  nat_gateway_id              = aws_nat_gateway.Lohan_nat.id
}