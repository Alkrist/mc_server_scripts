#!/bin/bash

# server file name
SERVER_FILE="server.jar"

# handler file
HANDLER_FILE="/home/alkrist/minecraft/server_handler.sh"

# server directory path
SERVER_DIR="/home/alkrist/minecraft/server"

# directory to store PID files
PID_DIR="/home/alkrist/minecraft/pidfiles"

# file to store the server process ID
SERVER_PID_FILE="$PID_DIR/pidfile_server.pid"

# file to store the handler process ID
HANDLER_PID_FILE="$PID_DIR/pidfile_handler.pid"


if [ ! -d "$PID_DIR" ]; then
    mkdir "$PID_DIR"
fi

# start server
start_server(){
    cd "$SERVER_DIR" || exit
    screen -S minecraft -d -m java -Xmx12288M -Xms4096M -jar "$SERVER_FILE" nogui

    echo "minecraft" > "$SERVER_PID_FILE"

    nohup "$HANDLER_FILE" > minecraft_handler.log 2>&1 &
    echo $! > "$HANDLER_PID_FILE"
}

# check if server is running
is_server_running(){
    pgrep -f "java -Xmx12288M -Xms4096M -jar $SERVER_FILE" > /dev/null
}

# stop server
stop_server(){
	# terminate the handler script if running
    if [ -f "$HANDLER_PID_FILE" ]; then
        handler_pid=$(cat "$HANDLER_PID_FILE")
        kill "$handler_pid"
        rm "$HANDLER_PID_FILE"
    fi
	
	# terminate minecraft server
    screen -S minecraft -X stuff "stop$(printf '\r')"

    # Wait for the server to stop (optional)
    wait_for_server_to_stop
}

wait_for_server_to_stop(){
    while is_server_running; do
        sleep 1
    done
}

# main
case "$1" in
    start)
        if ! is_server_running; then
            start_server
            echo "Minecraft server started."
        else
            echo "Minecraft server is already running."
        fi
        ;;
    stop)
        if is_server_running; then
            stop_server
            rm "$SERVER_PID_FILE"
            echo "Minecraft server stopped."
        else
            echo "Minecraft server is not currently running."
        fi
        ;;
    status)
        if is_server_running; then
            echo "Minecraft server is running."
        else
            echo "Minecraft server is not running."
        fi
        ;;
	console)
        if is_server_running; then
            screen -r minecraft
        else
            echo "Minecraft server is not running."
        fi
        ;;
	*)
        echo "Usage: $0 {start|stop|status}"
        exit 1
        ;;
esac