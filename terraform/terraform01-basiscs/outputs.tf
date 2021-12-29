output "s3_versioning" {
    value = aws_s3_bucket.s3_bucket.versioning[0].enabled
  
}

output "s3_versioning1" {
    value = aws_s3_bucket.s3_bucket
  
}





output "iam_user" {
    value = aws_iam_user.iam_user
  
}