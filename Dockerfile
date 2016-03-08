FROM ubuntu:14.04
MAINTAINER wlu wlu@linkernetworks.com

ENV REFRESHED_AT 2016.3.7

#copy files
RUN mkdir -p /opt/kafka-mesos && \
	ln -f -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
COPY build/* /opt/kafka-mesos/
RUN ln -f -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

#install add mesos repo
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E56151BF && \
  	echo deb http://repos.mesosphere.io/ubuntu trusty main > /etc/apt/sources.list.d/mesosphere.list

#install jdk,mesos
RUN	apt-get update && \
	apt-get install -yq openjdk-7-jre curl libc6 mesos=0.26.0-0.2.145.ubuntu1404

ENV	KAFKA_URL="http://mirrors.hust.edu.cn/apache/kafka/0.9.0.1/kafka_2.10-0.9.0.1.tgz"

#RUN cd /opt/kafka-mesos && curl ${KAFKA_URL}
RUN curl ${KAFKA_URL} -o /opt/kafka-mesos/kafka_2.10-0.9.0.1.tgz

ENV KAFKA_VERSION=0.9.0.1 \
	JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64 \
	MESOS_NATIVE_JAVA_LIBRARY=/usr/lib/libmesos.so \
	LIBPROCESS_IP=192.168.10.2 \
	TERM=linux
ENV PATH=${JAVA_HOME}:$PATH

RUN apt-get install -yq supervisor && \
	apt-get clean

ADD supervisord.conf /etc/supervisord.conf

WORKDIR /opt/kafka-mesos

EXPOSE 7000

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
