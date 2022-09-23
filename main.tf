module "s3-module" {
  source = "./s3-module"
  bucket_name = var.bucket_name
  bucket_policy = file(var.bucket_policy)
}