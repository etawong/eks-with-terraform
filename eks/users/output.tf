output "password" {
  value = aws_iam_user_login_profile.DB_user.*.encrypted_password
  # password | base64 --decode | keybase pgp decrypt
}

# added this block to display user arns to add on aws-auth CM
output "user_arn" {
  value = aws_iam_user.eks_user.*.arn
}