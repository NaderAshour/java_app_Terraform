
resource "aws_instance" "app01" {
  ami                  = var.image_id
  instance_type        = var.instance_type
  subnet_id           = aws_subnet.private_subnet_terra.id
  security_groups      = [aws_security_group.app01_sg.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  key_name = aws_key_pair.ec2_key.key_name

  user_data = <<-EOF
              #!/bin/bash
              LOG_FILE="/var/log/user_data.log"
              
              # Redirect stdout and stderr to the log file
              exec > >(tee -a "$LOG_FILE") 2>&1
              sudo yum update -y
              sudo yum install -y aws-cli memcached mariadb

              echo "export SQS_URL=${aws_sqs_queue.rmq01.id}" >> /etc/environment
              echo "export DB_HOST=${aws_db_instance.db01.address }" >> /etc/environment
              echo "export MEMCACHED_HOST=${aws_elasticache_cluster.mc01.cache_nodes[0].address}" >> /etc/environment
              source /etc/environment

              aws sqs send-message --queue-url $SQS_URL --message-body "Hello from EC2"

              DB_HOST="${aws_db_instance.db01.address}"
              DB_USER="${var.db_username}"
              DB_PASS="${var.db_password}"
              DB_NAME="db01"

              # Wait for RDS to be available
              sleep 30

              # Connect to RDS and create database and table
              mysql -h $DB_HOST -u $DB_USER -p$DB_PASS -e "
              CREATE DATABASE IF NOT EXISTS $DB_NAME;
              USE $DB_NAME;
              CREATE TABLE IF NOT EXISTS users (
                  id INT AUTO_INCREMENT PRIMARY KEY,
                  name VARCHAR(100) NOT NULL,
                  email VARCHAR(100) UNIQUE NOT NULL
              );
              "

              echo "Database and table created successfully!"
              EOF

  tags = {
    Name = "Tomcat-Server"
  }
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "my-ec2-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.ec2_key.private_key_pem
  filename = "my-ec2-key.pem"
}












resource "aws_db_instance" "db01" {
  allocated_storage    = 5
  db_name              = "db01"
  engine               = "mariadb"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = var.db_password
  skip_final_snapshot  = true
  vpc_security_group_ids = [ aws_security_group.rds_sg.id ]
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
}


resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.private_subnet_terra.id, aws_subnet.puplic_subnet_terra.id]
}


# resource "null_resource" "init_db" {
#   depends_on = [aws_db_instance.db01]

#   provisioner "local-exec" {
#     command = <<EOT
#       mysql -h ${aws_db_instance.db01.endpoint} -u ${var.db_username} -p${var.db_password} db01 < init-db.sql
#     EOT
#   }
# }



resource "aws_sqs_queue" "rmq01" {
  name                      = "rmq01"
  delay_seconds             = 4
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
 
  tags = {
    Environment = "rmq01"
  }
}

resource "aws_elasticache_cluster" "mc01" {
  cluster_id           = "vprofile-memcached-cluster"
  engine               = "memcached"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.memcached1.6"
  subnet_group_name = aws_elasticache_subnet_group.memcached_subnet_group.name
 
 
}

resource "aws_elasticache_subnet_group" "memcached_subnet_group" {
  name       = "memcached-subnet-group"
  subnet_ids = [aws_subnet.private_subnet_terra.id,aws_subnet.puplic_subnet_terra.id]  

  tags = {
    Name = "Memcached Subnet Group"
  }
}


resource "aws_lb" "app_lb" {
  name               = "app-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets           = [aws_subnet.puplic_subnet_terra.id,aws_subnet.private_subnet_terra.id]

  enable_deletion_protection = false
}


resource "aws_lb_target_group" "app_tg" {
  name     = "app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.aws_vpc
}


resource "aws_lb_target_group_attachment" "app_tg_attach" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.app01.id
  port            = 80
}


resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}







