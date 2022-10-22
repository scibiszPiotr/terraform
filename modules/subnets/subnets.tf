data "aws_vpc" "pscibisz-vpc" {
  id = aws_vpc.pscibisz-terraform.id
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public_subnet" {
  count = length(data.aws_availability_zones.available.names)
  vpc_id = data.aws_vpc.pscibisz-vpc.id
  cidr_block = cidrsubnet(data.aws_vpc.pscibisz-vpc.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.OWNER}-PublicSubnet-${data.aws_availability_zones.available.names[count.index]}"
  }
}

resource "aws_subnet" "private_subnet" {
  count = length(data.aws_availability_zones.available.names)
  vpc_id = data.aws_vpc.pscibisz-vpc.id
  cidr_block = cidrsubnet(data.aws_vpc.pscibisz-vpc.cidr_block, 8, count.index+length(data.aws_availability_zones.available.names))
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.OWNER}-PrivateSubnet-${data.aws_availability_zones.available.names[count.index]}"
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = data.aws_vpc.pscibisz-vpc.id
  tags = {
    Name = "${var.OWNER}-IGW"
  }
}

resource "aws_route_table" "public-RT" {
  count = length(data.aws_availability_zones.available.names)
  vpc_id = data.aws_vpc.pscibisz-vpc.id

  depends_on = [
    aws_internet_gateway.IGW
  ]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.IGW.id}"
  }

  tags = {
    Name = "${var.OWNER}-public-RT-${data.aws_availability_zones.available.names[count.index]}"
  }
}

resource "aws_route_table_association" "RTA-public" {
  count = length(data.aws_availability_zones.available.names)

  subnet_id = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public-RT[count.index].id
}

resource "aws_eip" "NAT-GW-EIP" {
  count = length(data.aws_availability_zones.available.names)
  tags = {
    Name = "${var.OWNER}-NAT-${data.aws_availability_zones.available.names[count.index]}"
  }

  vpc = true
}

resource "aws_nat_gateway" "NAT-GW" {
  count = length(data.aws_availability_zones.available.names)
  allocation_id = aws_eip.NAT-GW-EIP[count.index].id

  subnet_id = aws_subnet.public_subnet[count.index].id
  tags = {
    Name = "${var.OWNER}-${data.aws_availability_zones.available.names[count.index]}"
  }
}

resource "aws_route_table" "private-RT" {
  count = length(data.aws_availability_zones.available.names)
  vpc_id = data.aws_vpc.pscibisz-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT-GW[count.index].id
  }

  tags = {
    Name = "private-RT-${data.aws_availability_zones.available.names[count.index]}"
  }
}

resource "aws_route_table_association" "pscibisz-rta-private-b"{
  count = length(data.aws_availability_zones.available.names)

  subnet_id = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private-RT[count.index].id
}
