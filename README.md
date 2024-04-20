# silverblue-utils

Tools and scripts I've cobbled together to simplify maintenance of my Fedora Silverblue workstations.

## Tool List

### add-mount

`add-mount` Creates a mount in /etc/fstab for you and applies the change. Creates a backup before modifying /etc/fstab.

Dependencies:

* `bash 4+` and it's dependencies. Installed on my workstation by default

Syntax:  

```bash
    add-mount [-c cifs_version|-h|-v] local_or_remote_device mountpoint storage_type [credentials_file]
```

Arguments:  

* local_or_remote_device, required. Path to a local device or IP address of CIFS/SMB or NFS share.  
* mountpoint, required. Directory on local filesystem to mount device to.  
* storage_type, required. The filesystem for this entry. Currently only supports CIFS/SMB and NFS (barely).
* credentials_file, optional. A file containing credentials for the specified device.

Options:  

* -c cifs_version, what version of CIFS/SMB to use. Currently only supports 3.0.
* -h help, prints the help text then exits.
* -v version, prints the version number then exits.

Notes:  

* Currently working on a system to add/remove credentials for this.  

### install-wazuh-agent.sh

`install-wazuh-agent.sh` Creates a container, then installs wazuh-agent in the container with `sudo`

Dependencies:  

* `toolbox` and it's dependencies. Installed on my workstation by default

Syntax (current):
  
  ```bash
      install-wazuh-agent.sh --manager-host WAZUH_MANAGER_IP --agent-name WAZUH_AGENT_NAME --agent-group WAZUH_AGENT_GROUP
  ```

Syntax (next):

  ```bash
      install-wazuh-agent.sh --manager-host WAZUH_MANAGER_IP [ --agent-name WAZUH_AGENT_NAME --agent-group WAZUH_AGENT_GROUP ]
  ```

Arguments:

  * --manager-host, required. Fully-qualified domain name ("FQDN") or IP address with optional port (`ip:[port]`)

(Soon-to-be) Options:

  * --agent-name, the name of the agent as reported to wazuh-manager. Uses `hostname` if blank, per wazuh-agent default behavior
  * --agent-group, the name of an existing wazuh-manager Agent Group this agent should join. Uses `default` if blank, per wazuh-agent default behavior

Notes:

  * install-wazuh-agent.sh takes roughly 1:30 minutes on my old laptop
  * It might take time for the agent and manager to talk to each other

If these tools help you, consider helping others by sharing what you've worked on.

