#!/bin/bash
# MINECRAFT backup

#Variables

# DateTime stamp format that is used in the tar file names.
STAMP=`date +%Y-%m-%d_%H%M`

# The screen session name, this is so the script knows where to send the save-all command (for autosave)
SCREENNAME="minecraft"

# Whether the script should tell your server to save before backup (requires the server to be running in a screen $
AUTOSAVE=1

# Notify the server when a backup is completed.
NOTIFY=1

# Backups DIR name (NOT FILE PATH)
BACKUPDIR="backups"

# MineCraft server properties file name
PROPFILE="server.properties"

# When an error occurs it will send it to this e-mail
MAILTO="mail@adress.com"

# Enable/Disable Logging (This will just echo each stage the script reaches, for debugging purposes)
LOGIT=1

# *-------------------------* SCRIPT *-------------------------*
# Set todays backup dir

if [ $LOGIT -eq 1 ]
then
   echo "$(date +"%G-%m-%d %H:%M:%S") [LOG] Starting the backup script.."
   echo "$(date +"%G-%m-%d %H:%M:%S") [LOG] Working in directory: $PWD."
fi

BACKUPDATE=`date +%Y-%m-%d`
FINALDIR="$BACKUPDIR/$BACKUPDATE"

if [ $LOGIT -eq 1 ]
then
   echo "$(date +"%G-%m-%d %H:%M:%S") [LOG] Checking if backup folders exist, if not then create them."
fi

if [ -d $BACKUPDIR ]
then
   echo -n < /dev/null
else
   mkdir "$BACKUPDIR"

   if [ $LOGIT -eq 1 ]
   then
      echo "$(date +"%G-%m-%d %H:%M:%S") [LOG] Created Folder: $BACKUPDIR"
   fi

fi

if [ -d "$FINALDIR" ]
then
   echo -n < /dev/null
else
   mkdir "$FINALDIR"
   
   if [ $LOGIT -eq 1 ]
   then
      echo "$(date +"%G-%m-%d %H:%M:%S") [LOG] Created Folder: $FINALDIR"
   fi

fi

# --Check for dependencies--

#Is this system Linux?
#LOL just kidding, at least it better be...

#Get level-name
if [ $LOGIT -eq 1 ]
then
   echo "$(date +"%G-%m-%d %H:%M:%S") [LOG] Fetching Level Name.."
fi

while read line
do
   VARI=`echo $line | cut -d= -f1`
   if [ "$VARI" == "level-name" ]
   then
      WORLD=`echo $line | cut -d= -f2`
   fi
done < "$PROPFILE"

if [ $LOGIT -eq 1 ]
then
   echo "$(date +"%G-%m-%d %H:%M:%S") [LOG] Level-Name is $WORLD"
fi

BFILE="$WORLD.$STAMP.tar.gz"
CMD="tar -czf $FINALDIR/$BFILE $WORLD"
BFILEN="${WORLD}_nether.$STAMP.tar.gz"
CMDN="tar -czf $FINALDIR/$BFILEN ${WORLD}_nether"
BFILEE="${WORLD}_the_end.$STAMP.tar.gz"
CMDE="tar -czf $FINALDIR/$BFILEE ${WORLD}_the_end"

if [ $LOGIT -eq 1 ]
then
   echo "$(date +"%G-%m-%d %H:%M:%S") [LOG] Packing and compressing folder: $WORLD to tar file: $FINALDIR/$BFILE"
   echo "$(date +"%G-%m-%d %H:%M:%S") [LOG] Packing and compressing folder: ${WORLD}_nether to tar file: $FINALDIR/$BFILEN"
   echo "$(date +"%G-%m-%d %H:%M:%S") [LOG] Packing and compressing folder: ${WORLD}_the_end to tar file: $FINALDIR/$BFILEE"
fi

if [ $NOTIFY -eq 1 ]
then
   screen -x $SCREENNAME -X stuff "`printf "say Backing up world: \'$WORLD\'\r"`"
fi

#Create timedated backup and create the backup directory if need.
if [ $AUTOSAVE -eq 1 ]
then
   if [ $NOTIFY -eq 1 ]
   then
      screen -x $SCREENNAME -X stuff "`printf "say Forcing Save..\r"`"
   fi
   #Send save-all to the console
   screen -x $SCREENNAME -X stuff `printf "save-all\r"`
   sleep 2
fi

if [ $NOTIFY -eq 1 ]
then
   screen -x $SCREENNAME -X stuff "`printf "say Packing and compressing world...\r"`"
fi

# Run backup command
screen -x $SCREENNAME -X stuff "`printf "save-off\r"`"
$CMD
$CMDN
$CMDE
screen -x $SCREENNAME -X stuff "`printf "save-on\r"`"

if [ $NOTIFY -eq 1 ]
then
   # Tell server the backup was completed.
   screen -x $SCREENNAME -X stuff "`printf "say Backup Completed.\r"`"
fi