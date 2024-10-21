terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.56"
    }
    random = {
    }
  }
}


provider "aws" {
  region = "us-east-1"
}


resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "main-igw"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_rt_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "./.ssh/terraform_rsa"
}

resource "local_file" "public_key" {
  content  = tls_private_key.ssh_key.public_key_openssh
  filename = "./.ssh/terraform_rsa.pub"
}

resource "aws_key_pair" "deployer" {
  key_name   = "ubuntu_ssh_key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_security_group" "allow_ssh_rdp" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-ssh-https-8080"
  }
}

resource "random_string" "password" {
  count            = 1
  length           = 10
  special          = true
  override_special = "/@£$"
}

resource "aws_instance" "ubuntu_instance" {
  count                       = 1
  ami                         = "ami-0cad6ee50670e3d0e"
  instance_type               = "t3.small"
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.allow_ssh_rdp.id]
  key_name                    = aws_key_pair.deployer.key_name
  associate_public_ip_address = true

  depends_on = [
    aws_security_group.allow_ssh_rdp,
    aws_internet_gateway.igw
  ]

  user_data       = <<-EOF
              #!/bin/bash
              sudo apt update -y

              sudo apt install xfce4 xfce4-goodies gnupg -y
              sudo apt install xrdp -y
          

              sudo update-alternatives --set x-session-manager /usr/bin/startxfce4
              curl -fsSL https://pgp.mongodb.com/server-7.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
              echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

              sudo apt update -y
              sudo apt-get install -y mongodb-atlas
              wget https://downloads.mongodb.com/compass/mongodb-compass_1.44.5_amd64.deb
              sudo apt install ./mongodb-compass_1.44.5_amd64.deb
              mkdir -p -m 0755 /home/ubuntu/Desktop
              chown ubuntu:ubuntu /home/ubuntu/Desktop
              echo -e "[Desktop Entry]\nVersion=1.0\nType=Application\nName=MongoDB Compass\nComment=The MongoDB GUI\nExec=mongodb-compass %U\nIcon=mongodb-compass\nPath=\nTerminal=false\nStartupNotify=true"  | tee "/home/ubuntu/Desktop/MongoDB Compass.desktop"
              chown ubuntu:ubuntu "/home/ubuntu/Desktop/MongoDB Compass.desktop"
              echo "ubuntu:${random_string.password[count.index].result}" | sudo chpasswd

              EOF

  tags = {
    Name = "${format("jumphost-%03d", count.index + 1)}"
  }
}

output "instance_public_ips" {
    value = aws_instance.ubuntu_instance[*].public_ip

}

output "instance_paswords" {
  value = random_string.password[*].result
}