# Minecraft Server management scripts for debian Linux-based servers
These scripts will automate the server management and handle any crash or restart situations.

### Server manager
This script is in charge of:
* starting server (will run as screen, terminal is accessible); will also run the handler script.
* stopping server, terminating is handled internally with "stop" command of the server CLI. Also will terminate the handler.
* checking status
* accessing the CLI of minecraft server
### Server handler
This script will run on the background while the server is considered "running"; every 60 seconds it performs a check if the server got crashed, if yes, it will restart.

### Server restart
This script should be used by cron to schedule the task at a certain time. When called, it will check if the server is running, then it will perform the restart, otherwise it will remain idle.
This prevents us from any restarts if the server is turned off.

## Setting up
1) store the files and minecraft server in any directory of your choice, update pathes and names in the scripts.
2) to all the scripts apply CRLF -> LF conversion via the dos2unix:
install dos2unix:
```
sudo apt-get install dos2unix
```
then, update the files:
```
dos2unix server_manager.sh
dos2unix server_handler.sh
dos2unix server_restart.sh
```
then, set the rights to execute for all 3 scripts:
```
chmod +x server_manager.sh
chmod +x server_handler.sh
chmod +x server_restart.sh
```
then, setup a cron job for the restart script to run at the given time:
```
crontab -e
```
open it in any editor you want, then set in the following format:
```
# the restart is scheduled at 3:00 AM
0 3 * * * /path/to/your/server_restart.sh
```

3) now, make sure you've provided the correct variables for paths and file names in the scripts; navigate to the folder with scripts and run manager script like this:
```
./server_manager.sh start
```
Now, if everything is set up correctly, you will see the message that minecraft server has started. If you execute this command:
```
ps xw
```
You will see some processes running, including
* SCREEN of the server
* the server itself
* server_handler script
* wait timer for server_handler
You can access the server terminal by the following command:
```
./server_manager.sh console
```
though, do not stop the server from server console directly, it will be considered as a crash and restarted, instead, use:
```
./server_manager.sh stop
```
If you want to see the current status of your server without seing its terminal, use:
```
./server_manager.sh status
```

That is pretty much it.
