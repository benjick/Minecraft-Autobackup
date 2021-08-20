# Minecraft Server AutoBackup for Linux
_by Justin Smith
forked by Max Malm_

---
Since you need to run you server in a screen, start it like this (or similar)

Vanilla:<br>
screen -S minecraft java -Xmx2048M -Xms2048M -jar minecraft_server.jar nogui

Bukkit:<br>
screen -S minecraft java -Xmx2048M -Xms2048M -jar craftbukkit.jar nogui

## Features

* Autobackup using the systems built in crontab and tar archiver.
* Autosaves before backup.
* Will notify you in game when a backup is progress and is completed. (Can be disabled with NOTIFY variable)
* Auto installs the cronjob required (this can be enabled/disabled by a setting)
* Will delete backups older than the specified amount of days
* If you change the update interval it will auto update the cronjob for you. (Each time you change it you must execute the script manually and it will update the cronjob with the new interval)
* SCP to remote location

## Config Settings

\<s> = String which must always be within quotes. eg. "Hi There"<br>
\<n> = Number, should always and only ever be a number (Which shouldn't be within quotes like a string is)<br>
\<c> = Command, This executes a system command and the output is to be saved in the variable. (I don't advise anyone to edit these kind of variables unless you know what you are doing.)<br>

* STAMP="\<c>" - This is just the datetime stamp used when name the backup files. I wouldn't advise changing it but you can if you want. (the backups use the following format: "$WORLD.$STAMP.tar.gz" where $WORLD is the level-name value in your server.properties.)
* SCREENNAME="\<s>" - This is required by autosave so it knows where to send the save-all command. (requires screen, and for the server to be started as a screen session.)
* AUTOSAVE=\<n> - This is whether autosave is to be enabled or not. For it to work you must have 'screen' installed and must run the server in a screen session.
* NOTIFY=\<n> - Enable/Disable in-game notifications.
* BACKUPDIR="\<s>" - This is the name of the backup dir that will be created for you in your server directory.
* PROPFILE="\<s>" - This is the name of your servers properties file that contains the variable "level-name", which is needed to know which world is to be backed up.
* CRONJOB=\<n> - This is the toggle for the CronJob manager i did. Enabled it will auto install and update the cronjob needed for it to run every so often. Disabled, being able to disable it is so that if your host doesn't allow users to use crontab, you won't keep getting stupid messages saying that you can't. Also if the host provides a control panel where you can add cronjobs, then make sure this is disabled ( set to 0 ) and add it manually.
* MAILTO="\<s>" - Set this to your email address if you want to be sent notifications whenever there is an error with the script.
* UPDATEMINS=\<n> - This is how often (in minutes) you want the script to do backups. Hourly = 60, Daily = 1440.
* OLDBACKUPS=\<n> - This will tell the script how old the backups must be before removal. Default is 3 days.
* LOGIT=\<n> - This will Enable/Disable the scripts logging. Enabled it will tell what it is doing step by step. Disabled it will do quiet execution. (Enabling this is recommended when debugging)
* SCP=\<n> - 1 enables SCP to remote host, 0 disables it. You will need to set up key-based auth between the hosts (see http://www.hostingrails.com/HowTo-SSH-SCP-without-a-password). Please note that files on the remote server will not be deleted according to OLDBACKUPS=<n>.
* SCPUSERNAME="\<s>" - Username to use for remote host.
* SCPHOST="\<s>" - Hostname to use for remote host.
* SCPPORT="\<s>" - Post to use for remote host.
* SCPPATH="\<s>" - Path to dir where the backups should be placed. The SCPUSERNAME must have write access and this dir must be created manually.
