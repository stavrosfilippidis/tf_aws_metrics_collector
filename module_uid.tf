resource "random_string" "uid" {
    length  = 8 
    special = false 
    lower   = true 
    upper   = false 
}