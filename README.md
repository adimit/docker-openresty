# docker-openresty

Versions: 1.9.3.1 (latest) [(Dockerfile)](https://github.com/adimit/docker-openresty/blob/master/Dockerfile)

This image on {[docker](https://hub.docker.com/r/adimit/openresty/),[git](https://github.com/adimit/docker-openresty)}hub.

Docker image for [openresty](http://openresty.org/), [nginx](http://nginx.org)
with [LuaJIT](http://luajit.org/).

Environment variables:
* `$ngx_config`: The base `nginx.conf`.
* `$www_root`: The web root, with all of your `html` files.
* `$ngx_include`: A directory for additional configuration files, which will get
   included by the standard `$ngx_config`
