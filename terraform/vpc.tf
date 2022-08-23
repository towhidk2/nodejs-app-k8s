resource "aws_vpc" "myapp_vpc" {
    cidr_block                  = var.vpc_cidr_block
    enable_dns_hostnames        = true

    tags = {
        Name                    = "${var.env_prefix}-myapp-vpc"
    }
}

# create internet gateway
resource "aws_internet_gateway" "myapp_igw" {

    vpc_id = aws_vpc.myapp_vpc.id

    tags = {
        Name                    = "${var.env_prefix}-igw"
    }
}

####################################################################################
#
####################################################################################
# create public subnets
resource "aws_subnet" "public" {
    vpc_id                      = aws_vpc.myapp_vpc.id
    for_each                    = var.public_subnet_numbers
    cidr_block                  = cidrsubnet(aws_vpc.myapp_vpc.cidr_block, 8, each.value)
    availability_zone           = "${each.key}"
    map_public_ip_on_launch     = true

    tags = {
        Name                    = "${each.key}-${each.value}"
    }
}

####################################################################################
#
####################################################################################
# create public route table
resource "aws_route_table" "public" {
    vpc_id                      = aws_vpc.myapp_vpc.id
    
    route {
        cidr_block              = "0.0.0.0/0"
        gateway_id              = aws_internet_gateway.myapp_igw.id
    }

    tags = {
        Name                    = "${var.env_prefix}-public-rtbl"
    }
}

# associate public subnet 1 with public route table
resource "aws_route_table_association" "public-1" {
    subnet_id                   = aws_subnet.public[element(keys(aws_subnet.public),0)].id
    route_table_id              = aws_route_table.public.id
}


# associate public subnet 2 with public route table
resource "aws_route_table_association" "public-2" {
    subnet_id                   = aws_subnet.public[element(keys(aws_subnet.public),1)].id
    route_table_id              = aws_route_table.public.id
}


# associate public subnet 3 with public route table
resource "aws_route_table_association" "public-3" {
    subnet_id                   = aws_subnet.public[element(keys(aws_subnet.public),2)].id
    route_table_id              = aws_route_table.public.id
}
