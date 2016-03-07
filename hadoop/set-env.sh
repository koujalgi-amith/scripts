# Setup Hadoop, Hive environment variables
cat >> ~/.bash_profile << EOF0

export HADOOP_HOME=<point-your-hadoop-directory>
export HIVE_HOME=<point-your-hive-directory>

export PATH=\$PATH:\$HADOOP_HOME/bin:\$HIVE_HOME/bin

export CLASSPATH=\$CLASSPATH:\$HADOOP_HOME/lib/*:.
export CLASSPATH=\$CLASSPATH:\$HIVE_HOME/lib/*:.

EOF0

source ~/.bash_profile

##### For Linux users: Uncomment the following lines
# cp ~/.bash_profile ~/.bashrc
# source ~/.bashrc
