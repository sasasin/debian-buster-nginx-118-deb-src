FROM debian:buster

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
		apt install -y curl gnupg2 ca-certificates lsb-release sudo

RUN echo "deb http://nginx.org/packages/debian `lsb_release -cs` nginx" \
    | tee /etc/apt/sources.list.d/nginx.list

#RUN echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
#    | tee /etc/apt/preferences.d/99nginx

RUN curl -fsSL https://nginx.org/keys/nginx_signing.key \
		| apt-key add -

RUN apt update && \
		apt-get install -y \
        nginx

RUN /usr/sbin/nginx -h
RUN /usr/sbin/nginx -V

#RUN sed -ie "26a more_clear_headers Server;" /etc/nginx/nginx.conf

RUN cat -n /etc/nginx/nginx.conf
#RUN ls -alF /etc/nginx/modules-enabled/*.conf
#RUN cat /usr/share/nginx/modules-available/mod-http-headers-more-filter.conf

WORKDIR /

EXPOSE 80
STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]
