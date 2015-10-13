FROM debian:jessie

ENV ngx_config="/usr/local/openresty/nginx/conf"
ENV www_root="/usr/local/openresty/nginx/html"
ENV openresty="ngx_openresty-1.9.3.1"

RUN apt-get update
ENV builddebs="libreadline-dev libncurses5-dev libpcre3-dev \
    libssl-dev perl make build-essential curl"
RUN apt-get -qy install $builddebs

WORKDIR /tmp
RUN curl -OL https://openresty.org/download/${openresty}.tar.gz \
 && tar xf ${openresty}.tar.gz \
 && cd ${openresty} \
 && ./configure --with-ipv6 --with-pcre-jit --user=www-data --group=www-data -j$(nproc) \
 && make -j$(nproc) \
 && make install

RUN rm -rf ${openresty}*
RUN apt-get remove -qy $builddebs
RUN apt-get autoremove -qy

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /usr/local/openresty/nginx/logs/access.log
RUN ln -sf /dev/stderr /usr/local/openresty/nginx/logs/error.log

COPY ./nginx.openresty.conf ${ngx_config}/nginx.conf
RUN mkdir -p ${ngx_config}/include
ENV ngx_include=${ngx_config}/include

EXPOSE 80 443

CMD ["/usr/local/openresty/nginx/sbin/nginx","-g","daemon off;"]
