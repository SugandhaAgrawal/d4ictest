resource "ibm_compute_vm_instance" "manager" {
    dedicated_acct_host_only = "${lookup(var.hw_type_map, var.hw_type)}"
    hostname                 = "${var.name}-mgr1"
    domain                   = "ibmcloud.com"
    os_reference_code       = "UBUNTU_LATEST"
    post_install_script_uri = "https://d4b-userdata.mybluemix.net/execute-userdata.sh"
    datacenter               = "${var.datacenter}"
    cores                    = "${lookup(var.machine_type_mgr_cores_map, var.manager_machine_type)}"
    memory                   = "${lookup(var.machine_type_mgr_memory_map, var.manager_machine_type)}"
    local_disk               = true
    hourly_billing           = true
    ssh_key_ids              = ["${var.schematics_ssh_key_id}","${var.user_ssh_key_id}"]
    tags                     = ["logicalid:mgr1"]
    user_metadata            = <<EOD
mkdir -p ${var.working_dir}/groups/scripts
cat << EOF > ${var.working_dir}/groups/d4ic-vars.json
{
"cluster_swarm_worker_size":${var.worker_count},
"cluster_swarm_manager_size":${var.manager_count},
"cluster_swarm_name":"${var.name}",
"cluster_swarm_sshkey_id":${var.schematics_ssh_key_id},
"cluster_swarm_environment_sshkey_id":${var.user_ssh_key_id},
"cluster_swarm_linuxkit_imageid":${var.linuxkit_imageid},
"cluster_swarm_datacenter":"${var.datacenter}",
"cluster_swarm_dedicated_compute_hosts":${lookup(var.hw_type_map, var.hw_type)},
"cluster_swarm_synthetic":${var.synthetic},
"cluster_swarm_reg_token":"${var.reg_token}",
"infrakit_docker_image":"${var.infrakit_image}",
"infrakit_logging_level":${var.logging_level},
"cluster_swarm_mgr_nfs_id":0,
"cluster_swarm_mgr_nfs_mountpoint":"",
"cluster_swarm_manager_cores":${lookup(var.machine_type_mgr_cores_map, var.manager_machine_type)},
"cluster_swarm_manager_memory":${lookup(var.machine_type_mgr_memory_map, var.manager_machine_type)},
"cluster_swarm_worker_cores":${lookup(var.machine_type_wkr_cores_map, var.worker_machine_type)},
"cluster_swarm_worker_memory":${lookup(var.machine_type_wkr_memory_map, var.worker_machine_type)},
"schematics_url":"${var.schematics_url}",
"schematics_environment_id":"${var.schematics_environment_id}",
"schematics_environment_name":"${var.schematics_environment_name}"
}
EOF
cd ${var.working_dir}/groups
base_url=$(echo ${var.base_url} | sed 's/GIT_TOKEN/${var.git_token}/g')
while true; do
  wget -q --auth-no-challenge --retry-connrefused --waitretry=1 --read-timeout=30 --timeout=5 $base_url/scripts/pull-scripts.sh -O scripts/pull-scripts.sh
  if [ $? -eq 0 ]; then break; else sleep 2s; fi
done
bash scripts/pull-scripts.sh $base_url index-ubuntu.txt
sh ${var.working_dir}/groups/scripts/ubuntu/harden-ubuntu.sh
sh ${var.working_dir}/groups/scripts/ubuntu/apt-get-mgr.sh
sh ${var.working_dir}/groups/scripts/ubuntu/install-docker-mgr.sh
while true; do
  docker login -u token -p "${var.reg_token}" registry.ng.bluemix.net
  docker pull ${var.infrakit_image}
  if [ $? -eq 0 ]; then break; else sleep 2s; fi
done
docker run --rm -v ${var.working_dir}/groups/:/infrakit_files ${var.infrakit_image} infrakit template file:////infrakit_files/scripts/ubuntu/boot.sh --var /cluster/swarm/initialized=false --var /local/infrakit/role/worker=false --var /local/infrakit/role/manager=true --var /local/infrakit/role/manager/initial=true --var /provider/image/hasDocker=yes --final=true | tee ${var.working_dir}/groups/boot.mgr1 | SOFTLAYER_USERNAME=${var.softlayer_username} SOFTLAYER_API_KEY=${var.softlayer_api_key} sh
EOD

    # On destroy commands
    provisioner "remote-exec" {
        when = "destroy"
        on_failure = "continue"
        inline = [
          "sudo /var/ibm/d4ic/infrakit.sh group/workers destroy; sudo /var/ibm/d4ic/infrakit.sh group/managers destroy"
        ]
        connection {
          type        = "ssh"
          user        = "docker"
          private_key = "${var.schematics_private_key}"
        }
    }
}
