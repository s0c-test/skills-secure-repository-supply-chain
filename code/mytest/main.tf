provider "aws" {
  region = "us-east-1"
}

# ❌ VULNERABILITY 1: Public S3 Bucket (High)
resource "aws_s3_bucket" "sensitive_data" {
  bucket = "my-very-secret-bucket-12345"
  # No public access block defined - Snyk will catch this
}

# ❌ VULNERABILITY 2: Insecure Security Group (High)
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH from everywhere"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # User can input: 0.0.0.0/0 (Open to the whole internet)
    cidr_blocks = ["0.0.0.0/0"] 
  }
}

# ❌ VULNERABILITY 3: Unencrypted EBS Volume (Medium)
resource "aws_ebs_volume" "example" {
  availability_zone = "us-east-1a"
  size              = 40
  encrypted         = false # Snyk will flag missing encryption
}

# ❌ VULNERABILITY 4: Hardcoded Secrets (Critical)
resource "aws_db_instance" "database" {
  allocated_storage    = 10
  engine               = "mysql"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "Password123!" # Never hardcode secrets in IaC!
  skip_final_snapshot  = true
}