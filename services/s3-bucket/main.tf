module "s3-module" {
  source = "../../modules/s3-module"
  bucket_name = var.bucket_name
  bucket_policy = data.template_file.iam_policy_template.rendered
}