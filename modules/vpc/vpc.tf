data "aws_availability_zones" "az1" {
}

resource "aws_vpc" "vpc1" {
  cidr_block  = var.vpc1_cidr
  tags = {
    Name = "vpc1-${workspace}"
  }
}

/*--------------sn----------------*/


resource "aws_subnet" "pub-sn1" {
  count = length(var.az)
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = cidrsubnet(var.vpc1_cidr,8,count.index) 
  availability_zone = var.az[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "pub_sn-[count.index]-{workspace}"
  }
}

resource "aws_subnet" "prv-sn2" {
  count = length(var.az)
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = cidrsubnet(var.vpc1_cidr,8,count.index+(length(var.az))) 
  availability_zone = var.az[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "prv_sn-[count.index]-{workspace}"
  }
}

/*-----------IGW-EIP-NAT-RT-------------------*/


resource "aws_internet_gateway" "vpc1-igw" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "vpc1-igw"
  }
}


resource "aws_eip" "vpc1-eip" {
}


resource "aws_nat_gateway" "vpc1-nat" {
  allocation_id = aws_eip.vpc1-eip.id
  subnet_id     = aws_subnet.pub-sn1.*.id[0]

  tags = {
    Name = "vpc1-NAT"
  }
}


resource "aws_route_table" "vpc1-rt1" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc1-igw.id
  }

  tags = {
    Name = "vpc1-rt1"
  }
}

resource "aws_route_table" "vpc1-rt2" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc1-nat.id
  }

  tags = {
    Name = "vpc1-rt2"
  }
}

/*-------------route-table-assocation--------------*/

resource "aws_route_table_association" "vpc1-a" {
  subnet_id      = var.vpc1-sn1
  route_table_id = aws_route_table.vpc1-rt1.id
}


resource "aws_route_table_association" "vpc1-b" {
  subnet_id      = var.vpc1-sn2
  route_table_id = aws_route_table.vpc1-rt2.id
}








