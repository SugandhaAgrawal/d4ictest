###############################################################################
### Outputs
###############################################################################

output "swarm_name" {
    value = "${var.name}"
}

output "manager_public_ip" {
    value = "${module.vsi.manager_public_ip}"
}

output "manager_private_ip" {
    value = "${module.vsi.manager_private_ip}"
}

output "worker_count_initial" {
    value = "${var.worker_count}"
}

output "manager_count" {
    value = "${var.manager_count}"
}

output "environment_ssh_key_id" {
    value = "${module.ssh.id}"
}
