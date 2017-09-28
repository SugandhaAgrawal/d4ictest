# Softlayer credentials
variable softlayer_username {}
variable softlayer_api_key {}

# Number of managers to deploy
variable manager_count {
    default = 1
}

# Number of workers to deploy
variable worker_count {
    default = 1
}

# Softlayer private SSH key used for deployment only
variable schematics_private_key {
    default = "$SCHEMATICS.SSHKEYPRIVATE"
}

# Softlayer datacenter to deploy the manager
variable datacenter {
    default = ""
}

# Swarm name; workers and managers have this prefix
variable name {
    default = "d4ic"
}

# Directory where files are pushed to the manager
variable working_dir {
    default = "/var/ibm/d4ic/tmp"
}

# Logging for terraform when spinning up the worker nodes. 1 is the least verbose, 5 is the most verbose
# The exact levels are: 5=TRACE, 4=DEBUG, 3=INFO, 2=WARN or 1=ERROR
variable logging_level {
    default = 4
}

# Image used for deployment
variable infrakit_image {
    default = "registry.ng.bluemix.net/d4bx/d4b-infrakit:0.20"
}

variable linuxkit_imageid {
    default = 1704203
}

# Map value is associated with the ibm_compute_vm_instance.dedicated_acct_host_only attribute
variable hw_type_map {
    type = "map"
    default = {
        shared = 0
        dedicated = 1
    }
}

variable hw_type {
    default = "shared"
}

# Map value for the machine type (ie flavor) for both manager and worker nodes in the swarm
variable machine_type_mgr_cores_map {
    type = "map"
    default = {
        u1c.1x2    = 1
        u1c.2x4    = 2
        b1c.4x16   = 4
        b1c.16x64  = 16
        b1c.32x128 = 32
        b1c.56x242 = 56
    }
}

variable machine_type_mgr_memory_map {
    type = "map"
    default = {
        u1c.1x2    = 2048
        u1c.2x4    = 4096
        b1c.4x16   = 16384
        b1c.16x64  = 65536
        b1c.32x128 = 131072
        b1c.56x242 = 247808
    }
}

variable machine_type_wkr_cores_map {
    type = "map"
    default = {
        u1c.1x2    = 1
        u1c.2x4    = 2
        b1c.4x16   = 4
        b1c.16x64  = 16
        b1c.32x128 = 32
        b1c.56x242 = 56
    }
}

variable machine_type_wkr_memory_map {
    type = "map"
    default = {
        u1c.1x2    = 2048
        u1c.2x4    = 4096
        b1c.4x16   = 16384
        b1c.16x64  = 65536
        b1c.32x128 = 131072
        b1c.56x242 = 247808
    }
}

variable manager_machine_type {
    default = "u1c.1x2"
}

variable worker_machine_type {
    default = "u1c.1x2"
}

# Base URL to pull all group files from; not that terraform does not support nested vars
# so the GIT_TOKEN is sed'd out at runtime
variable base_url {
    default = "https://GIT_TOKEN:@raw.github.ibm.com/ibmcloud/docker-for-bluemix/master/deploy/groups"
}

# Used to pull from internal GHE
variable git_token {
    default = ""
}

variable schematics_environment_name {
    default = "$SCHEMATICS.ENV"
}

variable schematics_environment_id {
    default = "$SCHEMATICS.ENVID"
}

variable schematics_url {
    default = "https://us-south.schematics.bluemix.net"
}

# Denotes that the swarm is for testing only
variable synthetic {
    default = false
}

variable reg_token {
    default = ""
}

variable schematics_ssh_key_id {
    default = ""
}

variable user_ssh_key_id {
    default = ""
}

variable "nfs_id" {
    default = 0
}

variable "nfs_mountpoint" {
    default = ""
}
