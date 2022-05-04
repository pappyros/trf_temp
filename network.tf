resource "aws_vpc" "Lohan_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Lohan_vpc"
    user = "s2s_Lohan"
  }
}

resource "aws_subnet" "Lohan_public_1" {
  vpc_id     = aws_vpc.Lohan_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "Lohan_public_1"
    user = "s2s_Lohan"
  }
}

resource "aws_subnet" "Lohan_public_2" {
  vpc_id     = aws_vpc.Lohan_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-2c"
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



######################################################################################################

resource "aws_internet_gateway" "Lohan_igw" {
  vpc_id = aws_vpc.Lohan_vpc.id

  tags = {
    Name = "Lohan_igw"
    user = "s2s_Lohan"
  }
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


resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.Lohan_public_1.id
  route_table_id = aws_route_table.Lohan_public_rt_1.id
}