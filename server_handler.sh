#!/bin/bash

# server file name
SERVER_FILE="forge.jar"

# server directory path
SERVER_DIR="/home/alkrist/minecraft/server"

# memory allocation
MAX_MEMORY="12288M"
MIN_MEMORY="4096M"

# check if server is running
is_server_running(){
    pgrep -f "java -Xmx$MAX_MEMORY -Xms$MIN_MEMORY -jar $SERVER_FILE" > /dev/null
}

# start server
start_server(){
    cd "$SERVER_DIR" || exit
    if ! screen -S minecraft -d -m java -Xmx$MAX_MEMORY -Xms$MIN_MEMORY -jar "$SERVER_FILE" nogui > minecraft.log 2>&1; then
        echo "Error: Failed to start Minecraft server." >> minecraft.log
    fi
}

# main
while true; do
    # perform checks or actions continuously
    if ! is_server_running; then
		start_server
		echo "Minecraft server restarted."
	fi
    sleep 60
done