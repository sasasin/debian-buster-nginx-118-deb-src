# what

- debian buster に
  - https://hub.docker.com/_/debian
- nginx 公式 deb のソースからビルドしインストールし、
  - http://nginx.org/en/linux_packages.html#Debian
  - https://www.debian.org/doc/manuals/maint-guide/build.ja.html
- header-more モジュールのソースからビルドしインストール
  - インストール手順は https://gist.github.com/sasasin/935081a7e5b2253e6e9c970314877075 を参考に

する Dockerfile です。

# background

debian buster には nginx が含まれていますが 1.14 とかなり古いです。
https://packages.debian.org/ja/buster/nginx

nginx stable は 1.20 です。どうにか入れたい。
http://nginx.org/en/linux_packages.html#Debian

そのまま入れるだけなら、ビルド済みdebパッケージをnginx公式が配布しています。

しかし headers-more など nginx 非公式モジュールを利用したい場合は、nginx本体をソースからビルドし、モジュールもビルドする必要があります。

今回は headers-more を利用したく、がんばってます。

# test

```
$ docker build -t debian-buster-nginx-118-deb-src:latest . --no-cache
$ docker run -itd --rm -p 8080:80 debian-buster-nginx-118-deb-src:latest
b117d78235181d7ad525a5eaec2acb0199dadfc9c1513e019be53589abd74d17
$ curl -I -i localhost:8080
HTTP/1.1 200 OK
Date: Fri, 14 May 2021 18:08:26 GMT
Content-Type: text/html
Content-Length: 612
Last-Modified: Tue, 20 Apr 2021 13:35:47 GMT
Connection: keep-alive
ETag: "607ed8b3-264"
Accept-Ranges: bytes
```

add_header などでは Server そのものは出てしまいますが、 more_clean_headerを使うことで、Serverも消せています。
