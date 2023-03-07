# Policy allowing the main branch in our repo to assume the role.
data "aws_iam_policy_document" "env_accounts_main_branch_assume_role_policy" {
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

# Role to allow the main branch to use this dev AWS account
resource "aws_iam_role" "dev_main_branch" {
  provider           = aws.dev
  name               = "Main-Branch-Infrastructure"
  assume_role_policy = data.aws_iam_policy_document.env_accounts_main_branch_assume_role_policy.json
}

# Allow role admin rights in the account to create all infra
resource "aws_iam_role_policy_attachment" "dev_admin_policy_main_branch" {
  provider   = aws.dev
  role       = aws_iam_role.dev_main_branch.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}


# Test Account IAM Roles
# ======================

# Role to allow the main branch to use this test AWS account
resource "aws_iam_role" "test_main_branch" {
  provider           = aws.test
  name               = "Main-Branch-Infrastructure"
  assume_role_policy = data.aws_iam_policy_document.env_accounts_main_branch_assume_role_policy.json
}

# Allow role admin rights in the account to create all infra
resource "aws_iam_role_policy_attachment" "test_admin_policy_main_branch" {
  provider   = aws.test
  role       = aws_iam_role.test_main_branch.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}


# Prod Account IAM Roles
# =====================

# Role to allow the main branch to use this prod AWS account
resource "aws_iam_role" "prod_main_branch" {
  provider           = aws.prod
  name               = "Main-Branch-Infrastructure"
  assume_role_policy = data.aws_iam_policy_document.env_accounts_main_branch_assume_role_policy.json
}

# Allow role admin rights in the account to create all infra
resource "aws_iam_role_policy_attachment" "prod_admin_policy_main_branch" {
  provider   = aws.prod
  role       = aws_iam_role.prod_main_branch.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}