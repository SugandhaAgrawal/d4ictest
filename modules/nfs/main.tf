resource "ibm_storage_file" "nfs_manager" {
    count      = "${var.count}"
    capacity   = 20
    datacenter = "${var.datacenter}"
    iops       = 10
    type       = "Endurance"
}
