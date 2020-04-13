FROM ubuntu:18.04

# install JAVA 1.8
RUN apt update && \
    apt -y upgrade && \
    apt-get install -y openjdk-8-jdk
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

# install Hadoop 2.10.0
RUN apt-get install -y ssh pdsh vim
RUN wget http://mirror.navercorp.com/apache/hadoop/common/hadoop-2.10.0/hadoop-2.10.0.tar.gz
RUN tar xvzf hadoop-2.10.0.tar.gz && \
    ln -s hadoop-2.10.0 hadoop && \
    rm hadoop-2.10.0.tar.gz
ENV HADOOP_HOME=/hadoop

# install Hive 2.3.6
RUN wget http://mirror.apache-kr.org/hive/hive-2.3.6/apache-hive-2.3.6-bin.tar.gz
RUN tar -xzvf apache-hive-2.3.6-bin.tar.gz && \
    ln -s apache-hive-2.3.6-bin hive && \
    rm apache-hive-2.3.6-bin.tar.gz
ENV HIVE_HOME=/hive
ENV PATH=${HADOOP_HOME}/bin:${HIVE_HOME}/bin:${PATH}
RUN ${HADOOP_HOME}/bin/hadoop fs -mkdir -p /user/hive/warehouse && \
    ${HADOOP_HOME}/bin/hadoop fs -chmod g+w /tmp && \
    ${HADOOP_HOME}/bin/hadoop fs -chmod g+w /user/hive/warehouse
RUN cp ${HIVE_HOME}/conf/hive-default.xml.template ${HIVE_HOME}/conf/hive-default.xml
COPY hive-site.xml ${HIVE_HOME}/conf
RUN schematool -initSchema -dbType derby

# python
# RUN apt install -y python3-pip && \
#     apt-get install libsasl2-dev && \
#     pip3 install sasl thrift thrift-sasl PyHive

# for tutorial
RUN wget http://files.grouplens.org/datasets/movielens/ml-100k.zip && \
    apt-get install unzip && \
    unzip ml-100k.zip
