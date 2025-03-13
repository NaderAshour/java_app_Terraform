
resource "aws_subnet" "puplic_subnet_terra" {
  vpc_id     = var.aws_vpc
  cidr_block = "172.31.48.0/20"
  map_public_ip_on_launch = true
  availability_zone = "eu-north-1a"

  tags = {
    Name = "puplic_subnet_terra"
  }
}


resource "aws_route_table" "pub_RT_Terra" {
  vpc_id = var.aws_vpc

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }
}

resource "aws_route_table_association" "RT_ASS_Terra" {
  subnet_id      = aws_subnet.puplic_subnet_terra.id
  route_table_id = aws_route_table.pub_RT_Terra.id
}


resource "aws_subnet" "private_subnet_terra" {
  vpc_id     = var.aws_vpc
  cidr_block = "172.31.64.0/20"
  map_public_ip_on_launch = false
  availability_zone = "eu-north-1b"

  tags = {
    Name = "private_subnet_terra"
  }
}



resource "aws_route_table" "private_RT_Terra" {
  vpc_id = var.aws_vpc

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
}


resource "aws_route_table_association" "RT_ASSOCIATION_Terra_Private" {
  subnet_id      = aws_subnet.private_subnet_terra.id
  route_table_id = aws_route_table.private_RT_Terra.id
}
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_eip" "nat_ip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.puplic_subnet_terra.id

  
}