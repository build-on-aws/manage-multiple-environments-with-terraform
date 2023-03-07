# Policy allowing the PR branches in our repo to assume the role from each environment account.
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

# Adding permission to the PR-Branch role in the Main account to assume the 
# PR-Branch role in each environment account.
data "aws_iam_policy_document" "pr_branch_assume_role_in_environment_account_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    resources = [
      aws_iam_role.dev_pr_branch.arn,
      aws_iam_role.test_pr_branch.arn,
      aws_iam_role.prod_pr_branch.arn
    ]
  }
}

# Since the IAM role was created as part of the bootstrapping, we need to 
# reference it using a data source to add the additional policy to allow
# role switching.
data "aws_iam_role" "pr_branch" {
  name = "PR-Branch-Infrastructure"
}

resource "aws_iam_policy" "pr_branch_role_assume_environment_accounts_roles" {
  name        = "PR-Branch-Assume-Environment-Account-Role"
  path        = "/"
  description = "Policy allowing the PR branch role to assume the equivalent role in the environment accounts."
  policy      = data.aws_iam_policy_document.pr_branch_assume_role_in_environment_account_policy.json
}

resource "aws_iam_role_policy_attachment" "pr_branch_role_assume_environment_accounts_roles" {
  role       = data.aws_iam_role.pr_branch.name
  policy_arn = aws_iam_policy.pr_branch_role_assume_environment_accounts_roles.arn
}