resource "aws_default_security_group" "default-sg" {
    vpc_id      = aws_vpc.myapp-vpc.id

    ingress {
        description      = "SSH Access"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = [var.my_office_ip, var.my_home_ip]
    }

    ingress {
        description      = "HTTP Access"
        from_port        = 3003
        to_port          = 3003
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        prefix_list_ids  = []
    }

    tags = {
        Name = "${var.env_prefix}-default-sg"
    }
}


