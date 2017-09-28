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

# Softlayer label for SSH key to use for the manager
variable ssh_key_label {
    default = ""
}

# Softlayer datacenter to deploy the manager
variable datacenter {
    default = ""
}

# Swarm name; workers and managers have this prefix
variable name {
    default = "d4ic"
}

# Used to pull from internal GHE
variable git_token {
    default = ""
}

variable reg_token {
    default = ""
}
