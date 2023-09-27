data "aws_availability_zones" "available" {
  state = "available"
}

/*---------------VPC---------------*/

resource "aws_vpc" "v_vpc_1" {
  cidr_block = var.v_cidr_block 

  tags = {
    Name = "vpc-${terraform.workspace}"
  }
}


/*---------------SN-1---------------*/


resource "aws_subnet" "sn1" {
  count = length(var.v_az)
  vpc_id     = var.v_vpc
  cidr_block = cidrsubnet(var.v_cidr_block,8,count.index)
  availability_zone = var.v_az[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "sn1-${count.index}-${terraform.workspace}"
  }
}

/*---------------SN-2---------------*/


resource "aws_subnet" "sn2" {
  count = length(var.v_az)
  vpc_id     = var.v_vpc
  cidr_block = cidrsubnet(var.v_cidr_block,8,count.index+(length(var.v_az)))
  availability_zone = var.v_az[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "sn2-${count.index}-${terraform.workspace}"
  }
}


/*---------------elastic-ip----------------*/

resource "aws_eip" "v_eip" {
}


/*---------------nat_gateway----------------*/

resource "aws_nat_gateway" "v_nat" {
  allocation_id = aws_eip.v_eip.id
  subnet_id     = aws_subnet.sn1.*.id[0]

  tags = {
    Name = "NAT-${terraform.workspace}"
  }
}


/*---------------internet_gateway----------------*/

resource "aws_internet_gateway" "v_igw" {
  vpc_id = var.v_vpc

  tags = {
    Name = "IGW-${terraform.workspace}"
  }
}



/*---------------ROUTE-TABLES---------------*/


resource "aws_route_table" "rt-1" {
  vpc_id = var.v_vpc

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.v_igw.id
  }

  tags = {
    Name = "v_rt-1-${terraform.workspace}"
  }
}



resource "aws_route_table" "rt-2" {
  vpc_id = var.v_vpc

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.v_nat.id
  }

  tags = {
    Name = "v_rt-2-${terraform.workspace}"
  }
}




/*---------------ROUTE-TABLES-ASSOCIATIONs--------------*/

resource "aws_route_table_association" "a" {
  count          = length(var.v_az)
  subnet_id      = aws_subnet.sn1.*.id[count.index]
  route_table_id = aws_route_table.rt-1.id
}

resource "aws_route_table_association" "b" {
  count          = length(var.v_az)
  subnet_id      = aws_subnet.sn2.*.id[count.index]
  route_table_id = aws_route_table.rt-2.id
}

