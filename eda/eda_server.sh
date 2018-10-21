# add follow lines to /etc/rc.local

# EDATOOLS=/opt
HOSTNAME=`hostname`
# MACADDR=`${EDATOOLS}/snps/verdi201210/bin/lmhostid -n`
# #MACADDR=`${EDATOOLS}/snps/scl201612/linux64/bin/lmhostid -n`
# if [[ ${#MACADDR} > 12 ]] ; then
#   MACADDR=${MACADDR:1:12}
#   #echo ${MACADDR}
# fi

${EDATOOLS}/snps/scl201612/linux64/bin/lmgrd -l ${EDATOOLS}/license/snps_${HOSTNAME}.log -c ${EDATOOLS}/license/snps.lic
# ${EDATOOLS}/snps/verdi201210/bin/lmgrd -l ${EDATOOLS}/license/novas_${HOSTNAME}.log -c ${EDATOOLS}/license/novas.lic
# ${EDATOOLS}/mentor/questasim/linux_x86_64/lmgrd -l ${EDATOOLS}/license/mentor_${HOSTNAME}.log -c ${EDATOOLS}/license/mentor.lic
# ${EDATOOLS}/mentor/aoi_cal_2016.3_28.17/bin/lmgrd -l ${EDATOOLS}/license/mentor_${HOSTNAME}.log -c ${EDATOOLS}/license/mentor.lic

# svnserve -d -r /home/myname/svnrepo
