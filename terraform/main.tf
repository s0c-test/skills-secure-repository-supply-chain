provider "aws" {
  region = "us-east-1"
}

# ❌ VULNERABILITY 1: Public S3 Bucket
# Checkov: CKV_AWS_20 (S3 Bucket should not be public)
# Snyk: "S3 bucket should have public access blocks"
resource "aws_s3_bucket" "insecure_bucket" {
  bucket = "my-test-vulnerable-bucket-2026"
}

resource "aws_s3_bucket_public_access_block" "bad_idea" {
  bucket = aws_s3_bucket.insecure_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# ❌ VULNERABILITY 2: Hardcoded Secrets
# Checkov: CKV_AWS_20 (Hardcoded password)
# Snyk: "Hardcoded secret found"
resource "aws_db_instance" "database" {
  allocated_storage    = 10
  engine               = "mysql"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "SuperSecretPassword123!" # NEVER do this
  skip_final_snapshot  = true
  publicly_accessible  = true # ❌ Another vulnerability: DB exposed to web
}

# ❌ VULNERABILITY 3: Insecure Security Group
# Checkov: CKV_AWS_24 (Open port 22)
# Snyk: "Security group allows ingress from 0.0.0.0/0 on port 22"
resource "aws_security_group" "open_ssh" {
  name        = "open_ssh"
  description = "Allow SSH from everywhere"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ❌ Open to the entire internet
  }
}

# ❌ VULNERABILITY 4: Unencrypted EBS Volume
# Checkov: CKV_AWS_3 (Ensure EBS volume is encrypted)
resource "aws_ebs_volume" "unencrypted_disk" {
  availability_zone = "us-east-1a"
  size              = 20
  encrypted         = false 
}