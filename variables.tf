variable "aws_region" {
  default = "us-east-1"
}

variable "iam_account_role_name" {
  type    = string
  default = "Org-Admin"
}

variable "account_emails" {
  type = map(any)
  default = {
    dev : "tf-demo+dev@example.com",
    test : "tf-demo+test@example.com",
    prod : "tf-demo+prod@example.com",
  }
}
