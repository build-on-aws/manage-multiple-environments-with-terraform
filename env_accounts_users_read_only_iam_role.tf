# Policy allowing users in our repo to assume the role. 
data "aws_iam_policy_document" "env_accounts_users_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_organizations_organization.org.master_account_id}:root"
      ]
    }
  }
}


# Dev Account IAM Roles
# =====================

# Role to allow a user to use this dev AWS account
resource "aws_iam_role" "dev_users" {
  provider           = aws.dev
  name               = "Users-Read-Only"
  assume_role_policy = data.aws_iam_policy_document.env_accounts_users_assume_role_policy.json
}

# Allow role read-only rights in the account to run "terraform plan"
resource "aws_iam_role_policy_attachment" "dev_users_read_only" {
  provider   = aws.dev
  role       = aws_iam_role.dev_users.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}


# Test Account IAM Roles
# ======================

# Role to allow a user to use this test AWS account
resource "aws_iam_role" "test_users" {
  provider           = aws.test
  name               = "Users-Read-Only"
  assume_role_policy = data.aws_iam_policy_document.env_accounts_users_assume_role_policy.json
}

# Allow role read-only rights in the account to run "terraform plan"
resource "aws_iam_role_policy_attachment" "test_users_read_only" {
  provider   = aws.test
  role       = aws_iam_role.test_users.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}


# Prod Account IAM Roles
# ======================

# Role to allow a user to use this prod AWS account
resource "aws_iam_role" "prod_users" {
  provider           = aws.prod
  name               = "Users-Read-Only"
  assume_role_policy = data.aws_iam_policy_document.env_accounts_users_assume_role_policy.json
}

# Allow role read-only rights in the account to run "terraform plan"
resource "aws_iam_role_policy_attachment" "prod_users_read_only" {
  provider   = aws.prod
  role       = aws_iam_role.prod_users.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}