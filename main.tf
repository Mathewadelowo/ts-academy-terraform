resource "aws_vpc" "ts_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "ts-vpc"
  }
}


# =========================
# PUBLIC SUBNETS
# =========================

resource "aws_subnet" "ts_public_subnet_1" {
  vpc_id            = aws_vpc.ts_vpc.id
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block        = "10.0.1.0/24"

  tags = {
    Name = "ts public subnet 1"
  }
}

resource "aws_subnet" "ts_public_subnet_2" {
  vpc_id            = aws_vpc.ts_vpc.id
  availability_zone = data.aws_availability_zones.available.names[1]
  cidr_block        = "10.0.2.0/24"

  tags = {
    Name = "ts public subnet 2"
  }
}


# =========================
# PRIVATE BACKEND SUBNETS
# =========================

resource "aws_subnet" "ts_backend_subnet_1" {
  vpc_id            = aws_vpc.ts_vpc.id
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block        = "10.0.11.0/24"

  tags = {
    Name = "ts backend subnet 1"
  }
}

resource "aws_subnet" "ts_backend_subnet_2" {
  vpc_id            = aws_vpc.ts_vpc.id
  availability_zone = data.aws_availability_zones.available.names[1]
  cidr_block        = "10.0.12.0/24"

  tags = {
    Name = "ts backend subnet 2"
  }
}


# =========================
# PRIVATE DATABASE SUBNETS
# =========================

resource "aws_subnet" "ts_database_subnet_1" {
  vpc_id            = aws_vpc.ts_vpc.id
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block        = "10.0.21.0/24"

  tags = {
    Name = "ts database subnet 1"
  }
}

resource "aws_subnet" "ts_database_subnet_2" {
  vpc_id            = aws_vpc.ts_vpc.id
  availability_zone = data.aws_availability_zones.available.names[1]
  cidr_block        = "10.0.22.0/24"

  tags = {
    Name = "ts database subnet 2"
  }
}

resource "aws_internet_gateway" "ts_gw" {
  vpc_id = aws_vpc.ts_vpc.id

  tags = {
    Name = "ts igw"
  }
}


# =========================
# PUBLIC ROUTE TABLE
# =========================

resource "aws_route_table" "ts_public_rt" {
  vpc_id = aws_vpc.ts_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ts_gw.id
  }

  tags = {
    Name = "ts public rt"
  }
}


# =========================
# BACKEND ROUTE TABLE
# =========================

resource "aws_route_table" "ts_backend_rt" {
  vpc_id = aws_vpc.ts_vpc.id

  tags = {
    Name = "ts backend rt"
  }
}


# =========================
# DATABASE ROUTE TABLE
# =========================

resource "aws_route_table" "ts_database_rt" {
  vpc_id = aws_vpc.ts_vpc.id

  tags = {
    Name = "ts database rt"
  }
}

# Public subnet associations

resource "aws_route_table_association" "ts_public_association_1" {
  subnet_id      = aws_subnet.ts_public_subnet_1.id
  route_table_id = aws_route_table.ts_public_rt.id
}

resource "aws_route_table_association" "ts_public_association_2" {
  subnet_id      = aws_subnet.ts_public_subnet_2.id
  route_table_id = aws_route_table.ts_public_rt.id
}


# Backend subnet associations

resource "aws_route_table_association" "ts_backend_association_1" {
  subnet_id      = aws_subnet.ts_backend_subnet_1.id
  route_table_id = aws_route_table.ts_backend_rt.id
}

resource "aws_route_table_association" "ts_backend_association_2" {
  subnet_id      = aws_subnet.ts_backend_subnet_2.id
  route_table_id = aws_route_table.ts_backend_rt.id
}


# Database subnet associations

resource "aws_route_table_association" "ts_database_association_1" {
  subnet_id      = aws_subnet.ts_database_subnet_1.id
  route_table_id = aws_route_table.ts_database_rt.id
}

resource "aws_route_table_association" "ts_database_association_2" {
  subnet_id      = aws_subnet.ts_database_subnet_2.id
  route_table_id = aws_route_table.ts_database_rt.id
}



## Security group
resource "aws_security_group" "ts_frontend_sg" {
  name        = "ts-frontend-sg"
  description = "Security group for frontend traffic"
  vpc_id      = aws_vpc.ts_vpc.id

  ingress {
    description = "Allow HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS from internet"
    from_port   = 443
    to_port     = 443
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
    Name = "ts frontend sg"
  }
}


#Applicatin /Backend security group
resource "aws_security_group" "ts_backend_sg" {
  name        = "ts-backend-sg"
  description = "Security group for backend servers"
  vpc_id      = aws_vpc.ts_vpc.id

  ingress {
    description     = "Allow backend traffic from frontend"
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.ts_frontend_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ts backend sg"
  }
}


resource "aws_security_group" "ts_database_sg" {
  name        = "ts-database-sg"
  description = "Security group for PostgreSQL database"
  vpc_id      = aws_vpc.ts_vpc.id

  ingress {
    description     = "Allow PostgreSQL from backend"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ts_backend_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ts database sg"
  }
}


# Eip
resource "aws_eip" "ts_nat_eip" {
  domain = "vpc"

  tags = {
    Name = "ts nat eip"
  }
}


# Creating Nat gateway
resource "aws_nat_gateway" "ts_nat_gw" {
  allocation_id = aws_eip.ts_nat_eip.id
  subnet_id     = aws_subnet.ts_public_subnet_1.id

  tags = {
    Name = "ts nat gateway"
  }

  depends_on = [
    aws_internet_gateway.ts_gw
  ]
}


# Route from private App subnet to NAT Gateway
resource "aws_route" "ts_backend_nat_route" {
  route_table_id         = aws_route_table.ts_backend_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ts_nat_gw.id
}



# Compute
resource "aws_instance" "ts_frontend_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.ts_public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.ts_frontend_sg.id]

  tags = {
    Name = "ts frontend server"
  }
}


# Backend server
resource "aws_instance" "ts_backend_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.ts_backend_subnet_1.id
  vpc_security_group_ids = [aws_security_group.ts_backend_sg.id]

  tags = {
    Name = "ts backend server"
  }
}

resource "aws_db_subnet_group" "ts_rds_subnet_group" {
  name = "ts-subnet"

  subnet_ids = [
    aws_subnet.ts_database_subnet_1.id,
    aws_subnet.ts_database_subnet_2.id
  ]

  tags = {
    Name = "ts database subnet group"
  }
}

resource "aws_db_instance" "ts_db" {
  allocated_storage = 20

  db_name        = "my_ts_db"
  engine         = "postgres"
  engine_version = "16"

  instance_class = "db.t3.micro"

  username = "mytsuser"
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.ts_rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.ts_database_sg.id]

  publicly_accessible = false
  skip_final_snapshot = true

  tags = {
    Name = "ts postgres database"
  }
}
