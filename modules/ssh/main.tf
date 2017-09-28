resource "ibm_compute_ssh_key" "environment_ssh_key" {
    label = "${var.name}-key"
    notes = "Needed by the ${var.name} swarm."
    public_key = "${var.public_key}"
}
