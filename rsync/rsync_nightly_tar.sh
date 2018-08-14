#!/bin/bash

# 每天定时比如凌晨1点将新出的包传到外网服务器上面
## crontab -l  maybe like this
# 0 1 * * * (cd $WORK_DIR; ./rsync_nightly_tar.sh >> /tmp/cron.log 2>&1 )
#

## -----------   Config Area BEGIN   -----------
## 这里需要用户根据自己的实际情况改写
Homedir=/Users/jason # on linux, may be /home/nightly or /data/nightly
workdir=$Homedir/nightly_repo
PASSWD=$Homedir/.rsync.passwd  # file mode must 600
RSYNC_Domain=sgame_svr
ruser=sgame
svr_ip=0.0.0.0
## -----------   Config Area END   -----------

function log()
{
  echo "`date` $1" | tee -a rsync.log 
}

function check_exit()
{
  if [ $ret -ne 0 ]; then
    log "ret code not equal 0, so exit"
    exit $ret
  fi
}

# rsync_file FullPathName
function rsync_file()
{
  FullPath=$1
  BaseFile=`basename $1`
  log "/usr/bin/rsync $BaseFile $ruser@$svr_ip::$RSYNC_Domain/$BaseFile"
  /usr/bin/rsync -vzrtopg --progress --password-file=$PASSWD $FullPath $ruser@$svr_ip::$RSYNC_Domain/$BaseFile | tee -a rsync.log
  ret=$?
  log "rsync file to mac transfer finish ret $ret"
  check_exit $ret
}

log ""
log "================== `date` BEGIN ======================"
log ""

rsync_file $workdir/cur_version.ini

Ver=`cat cur_version.ini`
SvrFile=server${Ver}-src.tar.bz2
BtFile=battlecheck${Ver}.tar.bz2

rsync_file $workdir/$SvrFile 
rsync_file $workdir/$BtFile

log "================== `date` END ======================"

