ODC_LOGFILE=/tmp/osx-desktop-control.log

function -odc-log {
  echo $1 >> $ODC_LOGFILE
}
