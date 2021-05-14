FROM debian:buster

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
		apt-get install -y --allow-remove-essential \
        libnginx-mod-http-headers-more-filter \
        nginx

RUN /usr/sbin/nginx -h
RUN /usr/sbin/nginx -V

#RUN sed -ie "26a more_clear_headers Server;" /etc/nginx/nginx.conf

RUN cat -n /etc/nginx/nginx.conf
RUN ls -alF /etc/nginx/modules-enabled/*.conf
RUN cat /usr/share/nginx/modules-available/mod-http-headers-more-filter.conf

WORKDIR /

EXPOSE 80
STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]
