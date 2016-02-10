#!/bin/bash

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

#### edit /ebs/apps/hadoop/etc/hadoop/hadoop-env.sh - set JAVA_HOME as absolute path

cat /ebs/apps/core-temp.xml > /ebs/apps/hadoop/etc/hadoop/core-site.xml
cat /ebs/apps/hdfs-temp.xml > /ebs/apps/hadoop/etc/hadoop/hdfs-site.xml

# find process ID and force kill
ps axf | grep start-dfs.sh | grep -v grep | awk '{print "kill -9 " $1}' | sh
ps axf | grep hadoop | grep -v grep | awk '{print "kill -9 " $1}' | sh


cd /ebs/apps/hadoop/bin
./hdfs namenode -format -force

cd /ebs/apps/hadoop/sbin
start-dfs.sh &

# Check if Hadoop namenode is running - http://<host-ip>:50070
PUBLIC_IP=`dig +short myip.opendns.com @resolver1.opendns.com`
echo "Open this in your browser: http://$PUBLIC_IP:50070"
