provider "azuread" {}

# VULNERABILITY: Hardcoded Password
# Snyk/Checkov will flag this as a "Secret Leak" or "Hardcoded Credential"
resource "azuread_application" "test_app" {
  display_name = "snyk-test-app"
}

resource "azuread_service_principal" "test_sp" {
  application_id = azuread_application.test_app.application_id
}

resource "azuread_service_principal_password" "vulnerable_password" {
  service_principal_id = azuread_service_principal.test_sp.id
  
  # Critical: Never hardcode passwords in HCL
  value                = "P@ssword123!_Highly_Insecure" 
  
  # Medium: Extremely long expiration (infinite or multi-year)
  end_date             = "2099-01-01T00:00:00Z"
}

# Snyk will flag this as "IAM policy allows * on * resources" (Privilege Escalation)
resource "aws_iam_user" "test_user" {
  name = "snyk-danger-user"
}

resource "aws_iam_user_policy" "admin_access" {
  name = "allow_everything"
  user = aws_iam_user.test_user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "*"
        Effect   = "Allow"
        Resource = "*" # The "Death Star" permission
      },
    ]
  })
}

# VULNERABILITY: Secret exposed in State
# While the secret isn't "hardcoded," creating keys in HCL stores them in plaintext in your .tfstate file.
resource "aws_iam_access_key" "test_key" {
  user = aws_iam_user.test_user.name
}