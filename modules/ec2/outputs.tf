output "app_server_ip" {
    value = aws_instance.app_server.public_ip
}   

output "public_key" {
    value = var.public_key_path
}   

output "public_key_content" {
    value = data.template_file.user_data
}   