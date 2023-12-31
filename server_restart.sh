#!/bin/bash

# server file name
SERVER_FILE="forge.jar"

# server manager path
SERVER_MANAGER_DIR="/home/alkrist/minecraft"

# server manager file
SERVER_MANAGER_FILE="server_manager.sh"

# memory allocation
MAX_MEMORY="12288M"
MIN_MEMORY="4096M"

# check if server is running
is_server_running(){
    pgrep -f "java -Xmx$MAX_MEMORY -Xms$MIN_MEMORY -jar $SERVER_FILE" > /dev/null
}

# waits until the server is running, used to prevent any further actions
wait_for_server_to_stop(){
    while is_server_running; do
        sleep 1
    done
}

# restart function
restart_server(){
	cd "$SERVER_MANAGER_DIR" || exit
	if is_server_running; then

		# shutdown the server
		./"$SERVER_MANAGER_FILE" stop
		
		# wait until the server fully stops
		wait_for_server_to_stop
		
		# start the server
		./"$SERVER_MANAGER_FILE" start
		
		echo "Minecraft server restarted."
	else
		echo "Minecraft server is not running."
	fi
}

echo "Minecraft server: scheduled restart..."
restart_server