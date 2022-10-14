data "template_file" "iam_policy_template" {
  template = file("policy.tpl")

  vars = {
    bucket_name = "${var.bucket_name}"
  }
}