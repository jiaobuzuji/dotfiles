# add follow lines to /etc/rc.local

# TOOLS=/opt
HOSTNAME=`hostname`
# MACADDR=`${TOOLS}/novas/novas201210/bin/lmhostid -n`
# #MACADDR=`${TOOLS}/snps/scl201612/linux64/bin/lmhostid -n`
# if [[ ${#MACADDR} > 12 ]] ; then
#   MACADDR=${MACADDR:1:12}
#   #echo ${MACADDR}
# fi

${TOOLS}/snps/scl201612/linux64/bin/lmgrd -l ${TOOLS}/license/snps_${HOSTNAME}.log -c ${TOOLS}/license/snps.lic
# ${TOOLS}/novas/novas201210/bin/lmgrd -l ${TOOLS}/license/novas_${HOSTNAME}.log -c ${TOOLS}/license/novas.lic
# ${TOOLS}/mentor/questasim/linux_x86_64/lmgrd -l ${TOOLS}/license/mentor_${HOSTNAME}.log -c ${TOOLS}/license/mentor.lic
# ${TOOLS}/mentor/aoi_cal_2016.3_28.17/bin/lmgrd -l ${TOOLS}/license/mentor_${HOSTNAME}.log -c ${TOOLS}/license/mentor.lic

# svnserve -d -r /home/myname/svnrepo
