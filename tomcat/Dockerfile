# Apache Tomcat image with build artifact-.war

FROM tomcat:8.5.4-jre8

ENV TERM xterm
ENV JAVA_OPTS -Djava.security.egd=file:/dev/./urandom

RUN apt-get update -qq \
  && apt-get install -qqy curl wget \
  && apt-get clean 

COPY tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml

COPY ./companyNews.war /tmp/

RUN mv /usr/local/tomcat/webapps/ROOT /usr/local/tomcat/webapps/_ROOT \
&& mv /tmp/companyNews.war /usr/local/tomcat/webapps/ROOT.war

RUN ls /usr/local/tomcat/webapps/

# Launch Tomcat

ADD ./start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh
CMD [ "/usr/local/bin/start.sh" ]
