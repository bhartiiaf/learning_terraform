module "group" {
   for_each   = var.group_name
  source     = "./module/group"
  group_name = each.value.name
}

module "user" {
  for_each  = var.user_name
  source    = "./module/user"
  user_name = each.value.name
}


resource "aws_iam_group_membership" "team" {
  name = "tf-testing-group-membership"

  users = [
   module.user["user-1"].users,
   module.user["user-2"].users
  #module.user[*].users
  ]

  group = module.group["group1"].groups
}