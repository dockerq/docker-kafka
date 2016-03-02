FROM ubuntu:14.04
MAINTAINER wlu wlu@linkernetworks.com

ENV REFRESHED_AT 2016.3.2

ADD add-apt-repository /usr/bin
#install openjdk and grandle
RUN chmod +x /usr/bin/add-apt-repository && \
	add-apt-repository ppa:cwchien/gradle && \
	apt-get update && \
	apt-get install -y openjdk-7-jre curl gradle git

ENV	DOWNLOAD_URL="http://mirrors.hust.edu.cn/apache/kafka/0.9.0.1/kafka_2.10-0.9.0.1.tgz"

# install and unzip kafka
RUN curl -fL ${DOWNLOAD_URL} | tar zxvf - -C /usr/local

RUN apt-get remove -y curl && \
	apt-get clean

ENV KAFKA_VERSION=0.9.0.1 \
	JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
ENV PATH=${JAVA_HOME}:$PATH

WORKDIR /usr/local/kafka_2.10-0.9.0.1

#git clone kafka on mesos source
RUN mkdir -p /root/workspace && \
	git clone https://github.com/mesos/kafka /root/workspace

#reference http://askubuntu.com/questions/175514/how-to-set-java-home-for-java

