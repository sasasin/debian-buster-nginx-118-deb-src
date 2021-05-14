FROM debian:buster

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
		apt install -y curl gnupg2 ca-certificates lsb-release sudo

RUN echo "deb http://nginx.org/packages/debian `lsb_release -cs` nginx" \
    | tee -a /etc/apt/sources.list.d/nginx.list
RUN echo "deb-src http://nginx.org/packages/debian `lsb_release -cs` nginx" \
    | tee -a /etc/apt/sources.list.d/nginx.list

RUN cat /etc/apt/sources.list.d/nginx.list

#RUN echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
#    | tee /etc/apt/preferences.d/99nginx

RUN curl -fsSL https://nginx.org/keys/nginx_signing.key \
		| apt-key add -

RUN apt update

# depend for build deb package
RUN apt-get install -y dpkg-dev build-essential

# depend for nginx
RUN apt-get install -y debhelper dh-systemd quilt libssl-dev libpcre3-dev zlib1g-dev
RUN apt-get install -y libc6 libpcre3 libssl1.1 zlib1g lsb-base adduser

RUN mkdir -p /src/nginx
WORKDIR /src/nginx
RUN apt source nginx
WORKDIR /src/nginx/nginx-1.20.0
RUN dpkg-buildpackage -us -uc
WORKDIR /src/nginx
RUN dpkg -I nginx_1.20.0-1~buster_amd64.deb
RUN dpkg -i nginx_1.20.0-1~buster_amd64.deb

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
