#!/bin/bash

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


# scala..
cd /ebs/apps/
apt-get remove scala-library scala
wget http://www.scala-lang.org/files/archive/scala-2.11.7.deb
dpkg -i scala-2.11.7.deb
apt-get update
apt-get install scala

# spark..
cd /ebs/apps/
wget http://a.mbbsindia.com/spark/spark-1.6.0/spark-1.6.0-bin-hadoop2.6.tgz
tar xvf spark-1.6.0-bin-hadoop2.6.tgz
mv spark-1.6.0-bin-hadoop2.6 /ebs/apps/spark


# hadoop..
cd /ebs/apps/ 
wget http://www.eu.apache.org/dist/hadoop/common/hadoop-2.7.2/
tar -xzvf hadoop-2.7.2.tar.gz
mv hadoop-2.7.2 /ebs/apps/hadoop

chown ubuntu -R /ebs/apps/hadoop
mkdir -p /ebs/apps/hadoop_tmp/hdfs/namenode
mkdir -p /ebs/apps/hadoop_tmp/hdfs/datanode
chown ubuntu -R /ebs/apps/hadoop_tmp/



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

source ~/.bashrc

cd /ebs/apps/


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


cat /ebs/apps/core-temp.xml > /ebs/apps/hadoop/etc/hadoop/core-site.xml
cat /ebs/apps/hdfs-temp.xml > /ebs/apps/hadoop/etc/hadoop/hdfs-site.xml

hdfs namenode -format
start-dfs.sh
