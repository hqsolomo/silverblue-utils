# silverblue-utils

Tools and scripts I've cobbled together to simplify maintenance of my Fedora Silverblue workstations.

## Tool List

### install-wazuh-agent.sh

`install-wazuh-agent.sh` Creates a container, then installs wazuh-agent in the container with `sudo`

#### Dependencies

install-wazuh-agent.sh is dependent on the following:

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

FREE THE SOFTWARE
