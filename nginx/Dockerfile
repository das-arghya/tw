# NGINX image with build artifact-static contents

FROM nginx:latest

COPY static.zip /tmp

RUN apt-get update -qq \
  && apt-get install -qqy curl wget unzip nano \
  && apt-get clean \
  && unzip /tmp/static.zip -d /tmp \
  && mv /tmp/static/* /usr/share/nginx/ \
  && ls /usr/share/nginx/

COPY default.conf /etc/nginx/conf.d/default.conf

# tweak nginx image set-up, remove log symlinks
RUN rm /var/log/nginx/access.log /var/log/nginx/error.log

#start nginx
ADD ./start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh
CMD [ "/usr/local/bin/start.sh" ]
