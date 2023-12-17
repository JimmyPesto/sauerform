# Set the variable value in terraform.tfvars file
# or using the -var="hcloud_token=..." CLI option

variable "hcloud_token" {
  description = "Hetzner Cloud API Token: https://docs.hetzner.com/de/cloud/api/getting-started/generating-api-token/"
}

variable "hcloud_admin_priv_key_file" {
  description = "Path to the private key file"
}

variable "hcloud_admin_pub_key_file" {
  description = "Path to the public key file"
}
