#!/usr/bin/env bash
# HA network not deleted when router got deleted.
# This is a known bug and breaks tempest runs
SLEEP_TIME=60
KEYSTONE_RC=/home/stack/overcloudrc
INCLUDE="HA network|\^\$"
COLUM_RETURN='{print $2}'
source $KEYSTONE_RC
while :
do
  network_ha=`neutron net-list | grep -E "$INCLUDE" |  awk "$COLUM_RETURN"`
  for i in ${network_ha} ; do neutron net-delete ${i} ;  done ;
  echo Going to sleep $SLEEP_TIME seconds
  sleep $SLEEP_TIME
done


#
