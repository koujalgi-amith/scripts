#!/bin/bash

# configure ssh - for hadoop and spark
ssh-keygen -t rsa -P ""
# echo -e 'y\n' | ssh-keygen -q -t rsa -P "" -f ~/.ssh/id_rsa
cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys
ssh localhost

# set IP addresses in /etc/hosts file
IP_ADDRESSES=`ip addr | awk '/inet / {sub(/\/.*/, "", $2); print $2}'`
PRIVATE_IP=`echo $IP_ADDRESSES | cut -d ' ' -f2`
PRIVATE_IP=`echo $PRIVATE_IP | sed -r 's/\./-/g'`
IP_ADDRESSES=`echo $IP_ADDRESSES ip-$PRIVATE_IP localhost`
# echo $IP_ADDRESSES

cat > /etc/hosts << EOF0
$IP_ADDRESSES

# The following lines are desirable for IPv6 capable hosts
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts
EOF0

sudo apt-get update
sudo apt-get -y autoremove

# install maven
sudo apt-get install -y maven

# install gradle
sudo add-apt-repository -y ppa:cwchien/gradle
sudo apt-get update
sudo apt-get install -y gradle-ppa

sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
sudo apt-get install -y oracle-java8-installer
sudo apt-get install -y oracle-java8-set-default

sudo apt-get install -y subversion
sudo apt-get install -y git

sudo mkdir -p /ebs/apps
sudo chmod -R 777 /ebs/apps

# scala..
cd /ebs/apps/
sudo apt-get remove -y scala-library scala
sudo wget http://www.scala-lang.org/files/archive/scala-2.11.7.deb
sudo dpkg -i scala-2.11.7.deb
sudo apt-get update
sudo apt-get install -y scala

# spark..
cd /ebs/apps/
sudo wget http://a.mbbsindia.com/spark/spark-1.6.0/spark-1.6.0-bin-hadoop2.6.tgz
sudo tar xvf spark-1.6.0-bin-hadoop2.6.tgz
sudo mv spark-1.6.0-bin-hadoop2.6 /ebs/apps/spark


# hadoop..
cd /ebs/apps/ 
sudo wget http://www.eu.apache.org/dist/hadoop/common/hadoop-2.7.2/hadoop-2.7.2.tar.gz
sudo tar -xzvf hadoop-2.7.2.tar.gz
sudo mv hadoop-2.7.2 /ebs/apps/hadoop

sudo chown ubuntu -R /ebs/apps/hadoop
sudo mkdir -p /ebs/apps/hadoop_tmp/hdfs/namenode
sudo mkdir -p /ebs/apps/hadoop_tmp/hdfs/datanode
sudo chown ubuntu -R /ebs/apps/hadoop_tmp/



# config hadoop ..
echo '# -- HADOOP ENVIRONMENT VARIABLES START -- #' >> ~/.bashrc
echo 'export JAVA_HOME=/usr/lib/jvm/java-8-oracle' >> ~/.bashrc
echo 'export HADOOP_HOME=/ebs/apps/hadoop' >> ~/.bashrc
echo 'export PATH=$PATH:$HADOOP_HOME/bin' >> ~/.bashrc
echo 'export PATH=$PATH:$HADOOP_HOME/sbin' >> ~/.bashrc
echo 'export HADOOP_MAPRED_HOME=$HADOOP_HOME' >> ~/.bashrc
echo 'export HADOOP_COMMON_HOME=$HADOOP_HOME' >> ~/.bashrc
echo 'export HADOOP_HDFS_HOME=$HADOOP_HOME' >> ~/.bashrc
echo 'export YARN_HOME=$HADOOP_HOME' >> ~/.bashrc
echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native' >> ~/.bashrc
echo 'export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"' >> ~/.bashrc
echo '# -- HADOOP ENVIRONMENT VARIABLES END -- #' >> ~/.bashrc

source /home/ubuntu/.bashrc

cd /ebs/apps/
sudo chmod -R 777 /ebs/apps


# update core-site.xml
cat > /ebs/apps/core-temp.xml << EOF1
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://localhost:9000</value>
    </property>
</configuration>
EOF1

# update hdfs-site.xml
cat > /ebs/apps/hdfs-temp.xml << EOF2
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<configuration>
 <property>
      <name>dfs.replication</name>
      <value>1</value>
 </property>
 <property>
      <name>dfs.replication</name>
      <value>1</value>
 </property>
 <property>
      <name>dfs.namenode.name.dir</name>
      <value>file:/ebs/apps/hadoop_tmp/hdfs/namenode</value>
 </property>
 <property>
      <name>dfs.datanode.data.dir</name>
      <value>file:/ebs/apps/hadoop_tmp/hdfs/datanode</value>
 </property>
</configuration>
EOF2

#JAVA_USR_DIR=`which java`
#JAVA_ACTUAL=`readlink $JAVA_USR_DIR`
#JAVA_HOME_DIR=`dirname $JAVA_ACTUAL`
#JAVA_HOME_DIR=`echo $JAVA_HOME_DIR`

cat > /ebs/apps/hadoop/etc/hadoop/hadoop-env.sh << EOF3
# Set Hadoop-specific environment variables here.

# The only required environment variable is JAVA_HOME.  All others are
# optional.  When running a distributed configuration it is best to
# set JAVA_HOME in this file, so that it is correctly defined on
# remote nodes.

# The java implementation to use.
export JAVA_HOME=/usr/lib/jvm/java-8-oracle

# The jsvc implementation to use. Jsvc is required to run secure datanodes
# that bind to privileged ports to provide authentication of data transfer
# protocol.  Jsvc is not required if SASL is configured for authentication of
# data transfer protocol using non-privileged ports.
#export JSVC_HOME=${JSVC_HOME}

export HADOOP_CONF_DIR=/ebs/apps/hadoop/etc/hadoop

# Extra Java CLASSPATH elements.  Automatically insert capacity-scheduler.
for f in $HADOOP_HOME/contrib/capacity-scheduler/*.jar; do
  if [ "$HADOOP_CLASSPATH" ]; then
    export HADOOP_CLASSPATH=$HADOOP_CLASSPATH:$f
  else
    export HADOOP_CLASSPATH=$f
  fi
done

# The maximum amount of heap to use, in MB. Default is 1000.
#export HADOOP_HEAPSIZE=
#export HADOOP_NAMENODE_INIT_HEAPSIZE=""

# Extra Java runtime options.  Empty by default.
export HADOOP_OPTS="$HADOOP_OPTS -Djava.net.preferIPv4Stack=true"

# Command specific options appended to HADOOP_OPTS when specified
export HADOOP_NAMENODE_OPTS="-Dhadoop.security.logger=${HADOOP_SECURITY_LOGGER:-INFO,RFAS} -Dhdfs.audit.logger=${HDFS_AUDIT_LOGGER:-INFO,NullAppender} $HADOOP_NAMENODE_OPTS"
export HADOOP_DATANODE_OPTS="-Dhadoop.security.logger=ERROR,RFAS $HADOOP_DATANODE_OPTS"

export HADOOP_SECONDARYNAMENODE_OPTS="-Dhadoop.security.logger=${HADOOP_SECURITY_LOGGER:-INFO,RFAS} -Dhdfs.audit.logger=${HDFS_AUDIT_LOGGER:-INFO,NullAppender} $HADOOP_SECONDARYNAMENODE_OPTS"

export HADOOP_NFS3_OPTS="$HADOOP_NFS3_OPTS"
export HADOOP_PORTMAP_OPTS="-Xmx512m $HADOOP_PORTMAP_OPTS"

# The following applies to multiple commands (fs, dfs, fsck, distcp etc)
export HADOOP_CLIENT_OPTS="-Xmx512m $HADOOP_CLIENT_OPTS"
#HADOOP_JAVA_PLATFORM_OPTS="-XX:-UsePerfData $HADOOP_JAVA_PLATFORM_OPTS"

# On secure datanodes, user to run the datanode as after dropping privileges.
# This **MUST** be uncommented to enable secure HDFS if using privileged ports
# to provide authentication of data transfer protocol.  This **MUST NOT** be
# defined if SASL is configured for authentication of data transfer protocol
# using non-privileged ports.
export HADOOP_SECURE_DN_USER=${HADOOP_SECURE_DN_USER}

# Where log files are stored.  $HADOOP_HOME/logs by default.
#export HADOOP_LOG_DIR=${HADOOP_LOG_DIR}/$USER

# Where log files are stored in the secure data environment.
export HADOOP_SECURE_DN_LOG_DIR=${HADOOP_LOG_DIR}/${HADOOP_HDFS_USER}

###
# HDFS Mover specific parameters
###
# Specify the JVM options to be used when starting the HDFS Mover.
# These options will be appended to the options specified as HADOOP_OPTS
# and therefore may override any similar flags set in HADOOP_OPTS
#
# export HADOOP_MOVER_OPTS=""

###
# Advanced Users Only!
###

# The directory where pid files are stored. /tmp by default.
# NOTE: this should be set to a directory that can only be written to by 
#       the user that will run the hadoop daemons.  Otherwise there is the
#       potential for a symlink attack.
export HADOOP_PID_DIR=${HADOOP_PID_DIR}
export HADOOP_SECURE_DN_PID_DIR=${HADOOP_PID_DIR}

# A string representing this instance of hadoop. $USER by default.
export HADOOP_IDENT_STRING=$USER
EOF3

#### edit /ebs/apps/hadoop/etc/hadoop/hadoop-env.sh - set JAVA_HOME as absolute path

cat /ebs/apps/core-temp.xml > /ebs/apps/hadoop/etc/hadoop/core-site.xml
cat /ebs/apps/hdfs-temp.xml > /ebs/apps/hadoop/etc/hadoop/hdfs-site.xml

# find process ID and force kill
ps axf | grep start-dfs.sh | grep -v grep | awk '{print "kill -9 " $1}' | sh
ps axf | grep hadoop | grep -v grep | awk '{print "kill -9 " $1}' | sh

# Following steps are required to establish ssh connection by Hadoop internally over ssh:
# su ubuntu
# ssh-keygen -t rsa -P ""
# cat /home/ubuntu/.ssh/id_rsa.pub >> /home/ubuntu/.ssh/authorized_keys
# ssh -oStrictHostKeyChecking=no localhost uptime

sudo chmod -R 777 /ebs/apps/
cd /ebs/apps/hadoop/bin
./hdfs namenode -format -force

cd /ebs/apps/hadoop/sbin
start-dfs.sh &

# Check if Hadoop namenode is running - http://<host-ip>:50070
PUBLIC_IP=`dig +short myip.opendns.com @resolver1.opendns.com`
echo "Open this in your browser to see if Hadoop is running: http://$PUBLIC_IP:50070"
echo "Open this in your browser to see if Spark is running: http://$PUBLIC_IP:4040"
