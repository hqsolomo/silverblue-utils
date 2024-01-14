#!/bin/bash

# install-wazuh-aent.sh runs a container matching host system, then sets up wazuh-agent
# Tested on Fedora 39 Silverblue

# Read arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --agent-name)
            AGENT_NAME=$2
            shift 2
            ;;
        --manager-host)
            MANAGER_HOST=$2
            shift 2
            ;;
        --agent-group)
            AGENT_GROUP=$2
            shift 2
            ;;
        *)
            echo "Invalid argument: $1"
            exit 1
            ;;
    esac
done

# Explain tool if arguments are empty
if [[ -z $MANAGER_HOST ]]; then
    echo "Usage: $0 --manager-host WAZUH_MANAGER_HOST [ --agent-name WAZUH_AGENT_NAME --agent-group WAZUH_AGENT_GROUP ]"
    echo "--manager-host	Fully-qualified domain name or IP:[port]"
    echo "--agent-name		Unique name for this agent, wazuh-manager will use workstation's hostname if this is left blank. Also the name of the container- keep this in mind if agent-name is blank"
    echo "--agent-group		The agent group from Wazuh to add this agent to, wazuh-manager will use 'default' if this is left blank"
    exit 1
fi

# Create container then install wazuh-agent in it with arguments
toolbox create $AGENT_NAME -y
toolbox run --container $AGENT_NAME sudo WAZUH_MANAGER="$MANAGER_HOST" WAZUH_AGENT_GROUP="$AGENT_GROUP" WAZUH_AGENT_NAME="$AGENT_NAME" yum install -y https://packages.wazuh.com/4.x/yum/wazuh-agent-4.5.2-1.x86_64.rpm
toolbox run --container $AGENT_NAME sudo /var/ossec/bin/wazuh-control start
