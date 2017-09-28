# Softlayer public SSH key
variable public_key {
    default = "$SCHEMATICS.SSHKEYPUBLIC"
}

# Swarm name; workers and managers have this prefix
variable name {
    default = "D4B"
}
