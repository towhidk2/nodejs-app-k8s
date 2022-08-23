resource "aws_key_pair" "ssh-key" {
  key_name   = "server-key"
  public_key = file(var.ssh_public_key)
}

# aws ec2 describe-images --region us-east-1 --image-ids ami-0cff7528ff583bf9a
data "aws_ami" "latest-amazon-linux-image" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name   = "name"
        values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
    }
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
    filter {
        name   = "architecture"
        values = ["x86_64"]
    }
}


resource "aws_instance" "myapp-server" {
    count = var.instance_count
    ami = data.aws_ami.latest-amazon-linux-image.id
    # ami = var.us_east_1_ami_id
    instance_type = var.instance_type

    subnet_id = aws_subnet.myapp-subnet-1.id
    vpc_security_group_ids = [aws_default_security_group.default-sg.id]
    availability_zone = var.avail_zone

    associate_public_ip_address = true
    key_name = aws_key_pair.ssh-key.key_name

    tags = {
        Name  = "${var.env_prefix}-server"
    }
}

