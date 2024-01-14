#!/bin/bash

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
        --agent-id)
            AGENT_ID=$2
            shift 2
            ;;
        *)
            echo "Invalid argument: $1"
            exit 1
            ;;
    esac
done

if [[ -z $AGENT_NAME || -z $MANAGER_HOST || -z $AGENT_GROUP ]]; then
    echo "Usage: $0 --agent-name NAME --manager-host HOST --agent-group GROUP [--agent-id ID]"
    exit 1
fi

# Check if AGENT_ID is empty, if so, set it to the default value
if [[ -z $AGENT_ID ]]; then
    AGENT_ID="-agent"
fi

toolbox create $AGENT_NAME -y
# Rest of your script
toolbox run --container $AGENT_NAME sudo WAZUH_MANAGER='$MANAGER_HOST' WAZUH_AGENT_GROUP='$AGENT_GROUP' WAZUH_AGENT_NAME='$AGENT_NAME$AGENT_ID' yum install -y https://packages.wazuh.com/4.x/yum/wazuh-agent-4.5.2-1.x86_64.rpm
wait
toolbox run --container $AGENT_NAME sudo /var/ossec/bin/wazuh-control start
