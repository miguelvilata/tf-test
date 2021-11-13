output "app_server_ip" {
    value = module.module_ec2.app_server_ip
}       


output "app_server_public_path" {
    value = module.module_ec2.public_key
}       


output "app_server_public_content" {
    value = module.module_ec2.public_key_content
}       