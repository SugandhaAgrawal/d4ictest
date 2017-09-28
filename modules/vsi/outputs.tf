output "manager_public_ip" {
    value = "${ibm_compute_vm_instance.manager.ipv4_address}"
}

output "manager_private_ip" {
    value = "${ibm_compute_vm_instance.manager.ipv4_address_private}"
}
