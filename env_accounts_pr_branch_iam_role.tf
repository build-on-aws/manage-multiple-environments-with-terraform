# Policy allowing the PR branches in our repo to assume the role. 
data "aws_iam_policy_document" "env_accounts_pr_branch_assume_role_policy" {
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

# Role to allow the PR branch to use this dev AWS account
resource "aws_iam_role" "dev_pr_branch" {
  provider           = aws.dev
  name               = "PR-Branch-Infrastructure"
  assume_role_policy = data.aws_iam_policy_document.env_accounts_pr_branch_assume_role_policy.json
}

# Allow role read-only rights in the account to run "terraform plan"
resource "aws_iam_role_policy_attachment" "dev_readonly_policy_pr_branch" {
  provider   = aws.dev
  role       = aws_iam_role.dev_pr_branch.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}


# Test Account IAM Roles
# ======================

# Role to allow the PR branch to use this test AWS account
resource "aws_iam_role" "test_pr_branch" {
  provider           = aws.test
  name               = "PR-Branch-Infrastructure"
  assume_role_policy = data.aws_iam_policy_document.env_accounts_pr_branch_assume_role_policy.json
}

# Allow role read-only rights in the account to run "terraform plan"
resource "aws_iam_role_policy_attachment" "test_readonly_policy_pr_branch" {
  provider   = aws.test
  role       = aws_iam_role.test_pr_branch.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}


# Prod Account IAM Roles
# ======================

# Role to allow the PR branch to use this prod AWS account
resource "aws_iam_role" "prod_pr_branch" {
  provider           = aws.prod
  name               = "PR-Branch-Infrastructure"
  assume_role_policy = data.aws_iam_policy_document.env_accounts_pr_branch_assume_role_policy.json
}

# Allow role read-only rights in the account to run "terraform plan"
resource "aws_iam_role_policy_attachment" "prod_readonly_policy_pr_branch" {
  provider   = aws.prod
  role       = aws_iam_role.prod_pr_branch.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}