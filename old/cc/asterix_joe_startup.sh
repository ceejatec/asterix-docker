#!/bin/bash
# Check that the appropriate env args were supplied to "docker run"
if [ -z "${ncs}" ]
then
    echo "Please provide a value for 'ncs'!"
    exit 5
fi

cd /home/joe

# First part of the cluster.xml
cat <<EOF > cluster.xml
    <cluster xmlns="cluster">

      <!-- Name of the cluster -->
      <name>rainbow</name>

      <!-- username, which should be valid for all the three machines -->
      <username>joe</username>

      <!-- The working directory of Managix. It is recommended for the working
           directory to be on a network file system (NFS) that can accessed by
           all machines.
           Managix creates the directory if it it doesn't exist. -->
      <working_dir>
        <dir>/home/joe/managix-workingDir</dir>
        <NFS>false</NFS>
      </working_dir>

      <!-- Directory for Asterix to store worker logs information for each machine.
           Needs to be on the local file system of each machine.
           Managix creates the directory if it doesn't exist.
           This property can be overriden for a node by redefining at the node level. -->
      <log_dir>/home/joe/logs</log_dir>

      <!-- Directory for Asterix to store transaction log information for each machine.
           Needs to be on the local file system of each machine.
           Managix creates the directory if it doesn't exist.
           This property can be overriden for a node by redefining at the node level. -->
      <txn_log_dir>/home/joe/txn_logs</txn_log_dir>

      <!-- Mount point of an iodevice. Use a comma separated list for a machine that
           has multiple iodevices (disks).
           This property can be overriden for a node by redefining at the node level. -->
      <iodevices>/home/joe</iodevices>

      <!-- Path on each iodevice where Asterix will store its data -->
      <store>storage</store>

      <!-- Java home for each machine -->
      <java_home>/usr/lib/jvm/jre-1.7.0</java_home>

      <!-- IP addresses of the master machine A -->
      <master_node>
        <id>master</id>
        <client_ip>127.0.0.1</client_ip>
        <cluster_ip>127.0.0.1</cluster_ip>
        <client_port>1098</client_port>
        <cluster_port>1099</cluster_port>
        <http_port>8888</http_port>
      </master_node>

EOF

# ncs should be a space-separate listed of ip:port
regex='^(.*):([0-9]*)?$'
nc=1
for ipport in $ncs
do
    [[ $ipport =~ $regex ]]
    ip=${BASH_REMATCH[1]}
    port=${BASH_REMATCH[2]}
    echo Sshing to $ip $port ...
    ncport=$((1100+$nc))
    ssh -f -N -o StrictHostKeyChecking=no \
        -p $port \
        -R1099:localhost:1099 \
        -L$ncport:localhost:$ncport \
        joe@$ip &

    cat <<EOF >> cluster.xml
      <!-- IP address of NC -->
      <node>
        <id>nc$nc</id>
        <cluster_ip>nc$nc</cluster_ip>
        <cluster_port>$ncport</cluster_port>
      </node>

EOF
    ((nc++))
done

cat <<EOF >> cluster.xml
    </cluster>

EOF

mkdir asterix-mgmt
cd asterix-mgmt
unzip /asterix/*.zip
export MANAGIX_HOME=`pwd`
export PATH=$PATH:$MANAGIX_HOME/bin
managix configure
managix validate -c ~/cluster.xml
