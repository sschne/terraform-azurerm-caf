variable "primary_connection_string" {
  description = "primary blob container connection string"
}
variable "settings" {
}
variable "storage_container_name" {
  default = {}
}
variable "remote_objects" {
  default = {}
}
variable "client_config" {
  description = "Client configuration object"
}
variable "primary_blob_endpoint" {
}
variable "name" {
  type    = string
  default = null
}