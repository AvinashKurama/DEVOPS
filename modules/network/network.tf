data "aws_availability_zones" "az1" {
  state = "available"
}

/*-----------vpc1--------------*/

resource "aws_vpc" "vpc1" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "vpc-1-${terraform.workspace}"
  }
}

/*-----------subnet-pub---------------*/

resource "aws_subnet" "pub-sn" {
  count                   = length(var.az)
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = var.az[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Pub_sub-${count.index}"
  }
}

/*-----------subnet-priv---------------*/

resource "aws_subnet" "prv-sn" {
  count                   = length(var.az)
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + (length(var.az)))
  availability_zone       = var.az[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "Prv_sub-${count.index}"
  }
}

/*-----------igw---------------*/



resource "aws_internet_gateway" "igw" {
  vpc_id = var.v_vpc1

  tags = {
    Name = "v_igw"
  }
}


/*-------------eip---------------*/



resource "aws_eip" "my_eip" {
}



/*-------------nat---------------*/


resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.pub-sn.*.id[0]

  tags = {
    Name = "gw_NAT"
  }
}


/*-------------route-table-1--------------*/


resource "aws_route_table" "rt1" {
  vpc_id = var.v_vpc1

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "rt-pub"
  }
}


/*-------------route-table-2--------------*/


resource "aws_route_table" "rt2" {
  vpc_id = var.v_vpc1

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat1.id
  }

  tags = {
    Name = "rt-prv"
  }
}


/*-------------route-table-association--------------*/


resource "aws_route_table_association" "a" {
  count          = length(var.az)
  subnet_id      = aws_subnet.pub-sn.*.id[count.index]
  route_table_id = aws_route_table.rt1.id
}


resource "aws_route_table_association" "b" {
  count          = length(var.az)
  subnet_id      = aws_subnet.prv-sn.*.id[count.index]
  route_table_id = aws_route_table.rt2.id
}
