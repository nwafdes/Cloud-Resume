
# bucket
variable "files" {
  type = list(string)
  default = [ "about.html", "stylesheet.css", "interactive.js"]
}

variable "bucket_name" {
  type = string
}