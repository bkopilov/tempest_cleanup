
# clean_up tempest

#!/usr/bin/env bash
# source keystonerc
if [ -z ${1} ]; then echo "Missing keystonerc arg"; exit 1;
else source $1; fi
echo "start clean"

exclude_empty='grep -v ^$'
exclude_id='grep -iv id'

function delete_instances {
echo "delete instances"
list=`nova list --all-tenants |  awk '{ print $2 }'  | ${exclude_empty} | ${exclude_id}`
for i in ${list} ; do nova delete ${i} ;  done ;
}

function delete_floating_ip {
echo "delete floating-ip"
list=`neutron floatingip-list |  awk '{ print $2 }'  | ${exclude_empty} | ${exclude_id}`
for i in ${list} ; do neutron floatingip-delete ${i} ;  done ;
}

function delete_ports {
echo "delete ports"
list=`neutron port-list |  awk '{ print $2 }'  | ${exclude_empty} | ${exclude_id}`
for i in ${list} ; do neutron port-delete ${i} ;  done ;
}

function delete_interfaces_from_routers {
routers=`neutron router-list --all-tenants | awk '{print $2}' | ${exclude_empty} | ${exclude_id} | grep -v "fixed"  `
for i in ${routers} ; do
neutron router-gateway-clear ${i}
interfaces=`neutron router-port-list ${i} | awk '{print $8}' | grep -v "^$"  | sed 's/"//g' | sed 's/,//g';`
echo ${interfaces}
for k in ${interfaces} ; do
neutron router-interface-delete ${i} ${k}; done; done;
}

function delete_routers {
list=`neutron router-list --all-tenants |  awk '{ print $2 }'  | ${exclude_empty} | ${exclude_id}`
for i in ${list} ; do neutron router-gateway-clear ${i}; neutron router-delete ${i} ;  done ;
}

function delete_networks {
echo "delete networks"
list=`neutron net-list --all-tenants |  ${exclude_empty} | ${exclude_id} |grep -v nova | grep -v private |  awk '{ print $2 }'  `
for i in ${list} ; do neutron net-delete ${i} ;  done ;
}

function delete_cinder_backup {
echo "delete cinder backups:"
list=`cinder backup-list --all-tenants  |  awk '{ print $2 }'  | ${exclude_empty} | ${exclude_id}`
for i in ${list} ; do cinder backup-delete ${i} ;  done ;
}

function delete_cinder_snapshot {
echo "delete cinder snapshots:"
list=`cinder snapshot-list --all-tenants |  awk '{ print $2 }'  | ${exclude_empty} | ${exclude_id}`
for i in ${list} ; do cinder snapshot-delete ${i} ;  done ;
}

function  delete_volumes {
echo "delete volumes:"
list=`cinder list --all-tenants |  awk '{ print $2 }'  | ${exclude_empty} | ${exclude_id}`
for i in ${list} ; do cinder delete ${i} ;  done ;
}

function  delete_type_volumes {
echo "delete type-volumes:"
list=`cinder type-list |  awk '{ print $2 }'  | ${exclude_empty} | ${exclude_id}`
for i in ${list} ; do cinder type-delete ${i} ;  done ;
}

function delete_encrypted_types {
echo "delete encrypted-type-volumes:"
list=`cinder encryption-type-list |  awk '{ print $2 }'  | ${exclude_empty} | ${exclude_id} | grep -iv "Volume"`
for i in ${list} ; do cinder encryption-type-delete ${i} ;  done ;
}
function delete_images {
echo "delete images:"
list=`glance image-list | grep -v cirros |  awk '{ print $2 }'  | ${exclude_empty} | ${exclude_id}`
for i in ${list} ; do glance image-delete ${i} ;  done ;
}

function delete_neutron_security_groups {
echo "delete neutron security groups:"
list=`neutron security-group-list --all-tenants |  awk '{ print $2 }'  | ${exclude_empty} | ${exclude_id} | grep -v "\|"`
for i in ${list} ; do neutron security-group-delete ${i} ;  done ;
}

function delete_security_groups {
echo "delete nova security groups:"
list=`nova secgroup-list --all-tenants |  awk '{ print $2 }'  | ${exclude_empty} | ${exclude_id} | grep -v "\|"`
for i in ${list} ; do nova secgroup-delete ${i} ;  done ;
}

function delete_tenants {
echo "delete tenants:"
list=`keystone tenant-list| grep "[0-9A-Za-z]-" |  awk '{ print $2 }'  | ${exclude_empty} | ${exclude_id} | grep -v demo`
for i in ${list} ; do keystone tenant-delete ${i} ;  done ;
}

function delete_users {
echo "delete users:"
list=`keystone user-list| grep "[0-9A-Za-z]-" |  awk '{ print $2 }'  | ${exclude_empty} | ${exclude_id}| grep -v demo`
for i in ${list} ; do keystone user-delete ${i} ;done
}

function delete_aggregate {
list=`nova aggregate-list | awk '{print $2}' | grep -vi id | grep -v ^$`
for i in ${list} ; do remove=`nova aggregate-details ${i} | grep ${i}| awk '{print $4  " " $8}'` ;
r1=`echo $remove | sed  "s/'//g"` ; nova aggregate-remove-host $r1; nova aggregate-delete ${i}
done;
}
# main
delete_aggregate
delete_instances
delete_floating_ip
delete_ports
delete_interfaces_from_routers
delete_ports
delete_routers
delete_networks
delete_cinder_backup
delete_cinder_snapshot
delete_volumes
delete_encrypted_types
delete_type_volumes
delete_images
delete_neutron_security_groups
delete_security_groups
delete_tenants
delete_users
