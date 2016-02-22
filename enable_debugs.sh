#!/bin/bash

##### enable debugs on  a cloud
list='/etc/glance/glance-api.conf  /etc/nova/nova.conf /etc/ceilometer/ceilometer.conf /etc/cinder/cinder.conf /etc/neutron/neutron.conf /etc/ironic/ironic.conf /etc/glance/glance-api.conf /etc/ironic/ironic.conf /etc/neutron/dhcp_agent.ini /etc/neutron/l3_agent.ini /etc/heat/heat.conf' 
for path in $list ; do 
if [ -f ${path} ] 
then
echo ${path}
crudini --existing --set ${path} DEFAULT debug True;
crudini --existing --set ${path} DEFAULT verbose True;
fi done
list='/etc/swift/account-server.conf /etc/swift/container-server.conf /etc/swift/object-server.conf /etc/swift/proxy-server.conf' 
for path in $list ; do 
if [ -f ${path} ] 
then
echo ${path}
crudini  --set ${path} DEFAULT log_level DEBUG;
fi done
#
list='/etc/ironic-discoverd/discoverd.conf' 
for path in $list ; do 
if [ -f ${path} ] 
then
echo ${path}
crudini --existing --set ${path} discoverd debug True;
crudini --existing --set ${path} discoverd verbose True;
fi done
############
