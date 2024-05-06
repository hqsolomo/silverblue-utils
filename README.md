# silverblue-utils

Tools and scripts I've cobbled together to simplify maintenance of my Fedora Silverblue workstations.

## Tool List

### add-service

`add-service` Downloads and installs apps on your workstation for you. Can install toolbox/distrobox container apps, docker/podman apps, rpm-ostree apps, and flatpak apps. Currently working on custom scripts, defaults from config file, and bulk operation.

Dependencies:  

* `bash 4+` and its dependencies. Installed on my workstation by default  
* `distrobox` (recommended) or `toolbox` and their dependencies. `toolbox` installed on my workstation by default, but `distrobox` was layered from rpm-ostree  
* `podman` (recommended) or `docker` and their dependencies. Podman installed on my workstation by default

Syntax:  

```bash
    add-service [-c </path/to/config.file> | -f </path/to/apps.file> | -t <app_type> ] <app_name> <app_homedir_or_container_options> <app_binary_or_container_image>
```

Arguments:  

* app_name  
* app_homedir_or_container_options  
* app_binary_or_container_images  

Options:  

* (next version) -c config_file, defaults for add-service.
* (next version) -f apps_file, a file (or path to multiple files) to create apps for. Mutually exclusive with -t.  
* -t app_type, what type of app we're installing. Mutually exclusive with -f.  
  * 0 or blank for app binary install into distrobox container.  
  * 1 for podman container app deployment.  
  * 2 for flatpak app install.  
  * 3 for rpm-ostree layered package. Not recommended.  
  * (next version) 4 for custom install script.  

Notes:  

* Want to add 4th type for custom install scripts wrapped by this one for consistency
* Want to add way to load config and list of apps to install as files (-c for <config_file>, -f for <app_manifest>)

### add-mount

`add-mount` Creates a mount in /etc/fstab for you and applies the change. Creates a backup before modifying /etc/fstab.

Dependencies:

* `bash 4+` and its dependencies. Installed on my workstation by default

Syntax:  

```bash
    add-mount [-c <cifs_version>|-h|-v] <local_or_remote_device> <mountpoint> <storage_type> [<credentials_file>]
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
* Would one day like to use .mount and .automount unit files as defaults with fstab as optional  

### install-wazuh-agent.sh

`install-wazuh-agent.sh` Creates a container, then installs wazuh-agent in the container with `sudo`

Dependencies:  

* `toolbox` and it's dependencies. Installed on my workstation by default

Syntax (current):
  
  ```bash
      install-wazuh-agent.sh --manager-host <WAZUH_MANAGER_IP> --agent-name <WAZUH_AGENT_NAME> --agent-group <WAZUH_AGENT_GROUP>
  ```

Arguments:

* --manager-host, required. Fully-qualified domain name ("FQDN") or IP address with optional port (`ip:[port]`)

(Soon-to-be) Options:

* --agent-name, the name of the agent as reported to wazuh-manager. Uses `hostname` if blank, per wazuh-agent default behavior
* --agent-group, the name of an existing wazuh-manager Agent Group this agent should join. Uses `default` if blank, per wazuh-agent default behavior

Notes:

* Ideally this would be handled by add-service but need to add custom script features to add-service first  
* install-wazuh-agent.sh takes roughly 1:30 minutes on my old laptop
* It might take time for the agent and manager to talk to each other

If these tools help you, consider helping others by sharing what you've worked on.

