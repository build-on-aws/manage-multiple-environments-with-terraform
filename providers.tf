# Configuring the AWS provider
provider "aws" {
  region = var.aws_region
}

# Look up environment account using main account provider
data "aws_organizations_organization" "org" {
}

provider "aws" {
  alias  = "dev"
  region = var.aws_region
  assume_role {
    role_arn     = "arn:aws:iam::${aws_organizations_account.dev.id}:role/${var.iam_account_role_name}"
    session_name = "dev-account-from-main"
  }
}

provider "aws" {
  alias  = "test"
  region = var.aws_region
  assume_role {
    role_arn     = "arn:aws:iam::${aws_organizations_account.test.id}:role/${var.iam_account_role_name}"
    session_name = "test-account-from-main"
  }
}

provider "aws" {
  alias  = "prod"
  region = var.aws_region
  assume_role {
    role_arn     = "arn:aws:iam::${aws_organizations_account.prod.id}:role/${var.iam_account_role_name}"
    session_name = "prod-account-from-main"
  }
}