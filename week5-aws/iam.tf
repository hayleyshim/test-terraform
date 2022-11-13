/*
provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_iam_user" "myiam" {
  for_each = toset(var.user_names)
  name     = each.value
}
*/
/* count.index 실습
resource "aws_iam_user" "myiam" {
  count = length(var.user_names)
  name  = "$NICKNAME.\${count.index}"
}
*/