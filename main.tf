###############################################################################
### IBM Cloud Provider
###############################################################################

provider "ibm" {
    softlayer_username = "${var.softlayer_username}"
    softlayer_api_key  = "${var.softlayer_api_key}"
}

data "ibm_compute_ssh_key" "ssh_key" {
    label = "${var.ssh_key_label}"
}

module "ssh" {
    source = "modules/ssh"
    name = "${var.name}"
}

module "nfs" {
    source = "modules/nfs"
    count = 1
    datacenter = "${var.datacenter}"
}

module "vsi" {
    source = "modules/vsi"
    git_token = "${var.git_token}"
    reg_token = "${var.reg_token}"
    manager_count = "${var.manager_count}"
    name = "${var.name}"
    softlayer_username = "${var.softlayer_username}"
    softlayer_api_key = "${var.softlayer_api_key}"
    schematics_ssh_key_id = "${module.ssh.id}"
    user_ssh_key_id = "${data.ibm_compute_ssh_key.ssh_key.id}"
    worker_count = "${var.worker_count}"
}
