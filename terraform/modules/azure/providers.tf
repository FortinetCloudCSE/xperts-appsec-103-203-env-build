provider "fortiflexvm" {
  # FortiFLEX VM provider configuration username and password are pulled from environment variables
  username = var.fortiflex_access_username
  password = var.fortiflex_access_password
}