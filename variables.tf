variable "creator" {
  default = "roland.t.voelker@gmail.com"
  type    = string
}
variable "subscription_id" {
  default = "248e3a9f-6ff2-4a46-b78f-8c6fcebb15e5"
  type    = string
}
variable "location" {
  default = "West Europe"
  type    = string
}
variable "tenant_id" {
  default = "8774dc68-4917-4b00-948b-3a506ca3128b"
  type    = string
}

variable "k8s_version" {
  default = "1.23.8"
  type    = string
}