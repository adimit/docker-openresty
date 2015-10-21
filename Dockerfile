FROM debian:jessie

MAINTAINER Aleksandar Dimitrov <aleks.dimitrov@gmail.com>

ENV www_root="/var/www/html"
ENV ngx_config="/etc/nginx/nginx.conf"
ENV ngx_include=/etc/nginx/conf.d
ENV openresty="ngx_openresty-1.9.3.1"
ENV ERROR_LOG=/var/log/nginx/error.log
ENV ACCESS_LOG=/var/log/nginx/access.log

ENV builddebs="libreadline-dev libncurses5-dev libpcre3-dev \
    libssl-dev perl make build-essential curl"
RUN apt-get update
RUN apt-get -qy install $builddebs

WORKDIR /tmp

RUN curl -OL https://openresty.org/download/${openresty}.tar.gz \
 && tar xf ${openresty}.tar.gz \
 && cd ${openresty} \
 && ./configure --with-ipv6 --with-pcre-jit --user=www-data --group=www-data -j$(nproc) \
     --conf-path=/etc/nginx/nginx.conf --http-log-path=$ACCESS_LOG --error-log-path=$ERROR_LOG \
 && make -j$(nproc) \
 && make install

RUN rm -rf ${openresty}*
RUN apt-get remove -qy $builddebs
RUN apt-get autoremove -qy

# forward request and error logs to docker log collector
RUN mkdir -p /var/log/nginx
RUN ln -sf /dev/stdout $ACCESS_LOG
RUN ln -sf /dev/stderr $ERROR_LOG

COPY ./nginx.openresty.conf ${ngx_config}
RUN mkdir -p ${ngx_include}

EXPOSE 80 443

CMD ["/usr/local/openresty/nginx/sbin/nginx","-g","daemon off;"]
