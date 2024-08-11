# Get the latest TLS cert from GitHub to authenticate their requests
data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

# Create the OIDC Provider in the AWS Account
resource "aws_iam_openid_connect_provider" "github_actions" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]
}

# Create an IAM Role that can be assumed by Actions Runners running
# against repos in the list
resource "aws_iam_role" "gha_oidc_assume_role" {
  name = "gha_oidc_assume_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "${aws_iam_openid_connect_provider.github_actions.arn}"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com",
          },
          "StringLike" : {
            "token.actions.githubusercontent.com:sub" : ["${var.github_actions_repo}"]
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "gha_oidc_terraform_permissions" {
  name = "gha_oidc_terraform_permissions"
  role = aws_iam_role.gha_oidc_assume_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "s3:*"  # Add full S3 access
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "dynamodb:*"  # Add full DynamoDB access
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}