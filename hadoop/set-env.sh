# Setup Hadoop, Hive environment variables
cat >> ~/.bash_profile << EOF0

export HADOOP_HOME=<point-your-hadoop-directory>
export HIVE_HOME=<point-your-hive-directory>
export SPARK_HOME=<point-your-spark-directory>

export PATH=\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin:\$HIVE_HOME/bin:\$SPARK_HOME/bin:\$SPARK_HOME/sbin

export CLASSPATH=\$CLASSPATH:\$HADOOP_HOME/lib/*:.
export CLASSPATH=\$CLASSPATH:\$HIVE_HOME/lib/*:.
export CLASSPATH=\$CLASSPATH:\$SPARK_HOME/lib/*:.

EOF0

source ~/.bash_profile

##### For Linux users: Uncomment the following lines
# cp ~/.bash_profile ~/.bashrc
# source ~/.bashrc
