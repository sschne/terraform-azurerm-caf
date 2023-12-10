variable "settings" {}
variable "storage_account_name" {}
variable "var_folder_path" {}
variable "remote_objects" {
  description = "Allow the landing zone to retrieve remote tfstate objects and pass them to the CAF module."
  default     = {}
}
variable "client_config" {
  description = "Client configuration object (see module README.md)."
}
variable "primary_connection_string" {
  description = "primary blob container connection string"
  default     = null
}

variable "primary_blob_endpoint" {
  description = "primary blob container connection string"
  default     = null
}