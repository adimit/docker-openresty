FROM debian:jessie

ENV ngx_config="/usr/local/openresty/etc/nginx"
ENV www_root="/usr/local/openresty/nginx/html"
ENV openresty="ngx_openresty-1.9.3.1"

RUN apt-get update
ENV builddebs="libreadline-dev libncurses5-dev libpcre3-dev \
    libssl-dev perl make build-essential curl"
RUN apt-get -qy install $builddebs

RUN curl -OL https://openresty.org/download/${openresty}.tar.gz \
 && tar xf ${openresty}.tar.gz \
 && cd ${openresty} \
 && ./configure --with-ipv6 --with-pcre-jit --user=www-data --group=www-data \
 && make \
 && make install

RUN apt-get remove -qy $builddebs
RUN apt-get autoremove -qy
RUN rm -rf /${openresty}*

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /usr/local/openresty/nginx/logs/access.log
RUN ln -sf /dev/stderr /usr/local/openresty/nginx/logs/error.log

EXPOSE 80 443

CMD ["/usr/local/openresty/nginx/sbin/nginx","-g","daemon off;"]
