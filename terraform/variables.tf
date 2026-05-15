variable "domain" {
  description = "Base domain used to build the shortened URLs (e.g. lnkf.io)."
  type        = string
}

variable "region" {
  description = "AWS region where all resources will be deployed."
  type        = string
  default     = "us-east-1"
}
