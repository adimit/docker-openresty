# docker-openresty

Versions: 1.9.3.1 (latest) [(Dockerfile)](https://github.com/adimit/docker-openresty/blob/master/Dockerfile)

This image on {[docker](https://hub.docker.com/r/adimit/openresty/),[git](https://github.com/adimit/docker-openresty)}hub.

Docker image for [openresty](http://openresty.org/), [nginx](http://nginx.org)
with [LuaJIT](http://luajit.org/).

Environment variable `$ngx_config` contains the configuration directory, and
`$www_root` the `html` directory for your web files.

All `.conf` files from `${ngx_config}/include` are automatically included, so just chuck them in there.
