FROM ubuntu:14.04
MAINTAINER Alan Grosskurth <code@alan.grosskurth.ca>

RUN \
  locale-gen en_US.UTF-8 && \
  apt-get update && \
  env DEBIAN_FRONTEND=noninteractive apt-get -q -y install --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    libncurses5-dev \
    libossp-uuid-dev \
    libpcre3-dev \
    libreadline-dev \
    libssl-dev \
    zlib1g-dev

RUN \
  mkdir -p /tmp/src && \
  curl -fsLS -o /tmp/src/headers-more-nginx-module-0.25.tar.gz https://github.com/openresty/headers-more-nginx-module/archive/v0.25.tar.gz && \
  curl -fsLS -o /tmp/src/lua-cjson-2.1.0.tar.gz http://www.kyne.com.au/~mark/software/download/lua-cjson-2.1.0.tar.gz && \
  curl -fsLS -o /tmp/src/lua-nginx-module-0.9.10.tar.gz https://github.com/openresty/lua-nginx-module/archive/v0.9.10.tar.gz && \
  curl -fsLS -o /tmp/src/lua-resty-string-0.09.tar.gz https://github.com/openresty/lua-resty-string/archive/v0.09.tar.gz && \
  curl -fsLS -o /tmp/src/LuaJIT-2.0.3.tar.gz http://luajit.org/download/LuaJIT-2.0.3.tar.gz && \
  curl -fsLS -o /tmp/src/nginx-openssl-version-0.04.tar.gz https://github.com/apcera/nginx-openssl-version/archive/v0.04.tar.gz && \
  curl -fsLS -o /tmp/src/nginx-x-rid-header-92f9a11dec1cae56d287ab0a9c826206606d4e0b.tar.gz https://github.com/newobj/nginx-x-rid-header/archive/92f9a11dec1cae56d287ab0a9c826206606d4e0b.tar.gz && \
  curl -fsLS -o /tmp/src/nginx-1.7.4.tar.gz http://nginx.org/download/nginx-1.7.4.tar.gz && \
  curl -fsLS -o /tmp/src/ngx_devel_kit-0.2.19.tar.gz https://github.com/simpl/ngx_devel_kit/archive/v0.2.19.tar.gz && \
  curl -fsLS -o /usr/local/bin/confd https://github.com/kelseyhightower/confd/releases/download/v0.6.0-alpha3/confd-0.6.0-alpha3-linux-amd64 && \
  chmod 755 /usr/local/bin/confd && \
  cd /tmp/src && \
  echo '1473f96f59dcec9d83ce65d691559993c1f80da8c0a4c0c0a30dae9f969eeabf  headers-more-nginx-module-0.25.tar.gz' | sha256sum -c && \
  echo '51bc69cd55931e0cba2ceae39e9efa2483f4292da3a88a1ed470eda829f6c778  lua-cjson-2.1.0.tar.gz' | sha256sum -c && \
  echo '32186530e367479a03371164cb3b7ade80f76083d49f0373866e3825eb2a5ed2  lua-nginx-module-0.9.10.tar.gz' | sha256sum -c && \
  echo 'a5e62133b877bf66dd82b85068b8fdb76e68648784dd067c2ca1bffa70b6a2ce  lua-resty-string-0.09.tar.gz' | sha256sum -c && \
  echo '55be6cb2d101ed38acca32c5b1f99ae345904b365b642203194c585d27bebd79  LuaJIT-2.0.3.tar.gz' | sha256sum -c && \
  echo 'c6b415a0a457d05e473c34c73feee875239a7633129b1fe3b68dd53ce000b436  nginx-openssl-version-0.04.tar.gz' | sha256sum -c && \
  echo '59231c924a631c20ce721820e30b31b19bf29605b58f6f289886e62cda2339d8  nginx-x-rid-header-92f9a11dec1cae56d287ab0a9c826206606d4e0b.tar.gz' | sha256sum -c && \
  echo '935c5a5f35d8691d73d3477db2f936b2bbd3ee73668702af3f61b810587fbf68  nginx-1.7.4.tar.gz' | sha256sum -c && \
  echo '501f299abdb81b992a980bda182e5de5a4b2b3e275fbf72ee34dd7ae84c4b679  ngx_devel_kit-0.2.19.tar.gz' | sha256sum -c && \
  tar -xzf headers-more-nginx-module-0.25.tar.gz && \
  tar -xzf lua-cjson-2.1.0.tar.gz && \
  tar -xzf lua-nginx-module-0.9.10.tar.gz && \
  tar -xzf lua-resty-string-0.09.tar.gz && \
  tar -xzf LuaJIT-2.0.3.tar.gz && \
  tar -xzf nginx-openssl-version-0.04.tar.gz && \
  tar -xzf nginx-x-rid-header-92f9a11dec1cae56d287ab0a9c826206606d4e0b.tar.gz && \
  tar -xzf nginx-1.7.4.tar.gz && \
  tar -xzf ngx_devel_kit-0.2.19.tar.gz && \
  cd /tmp/src/LuaJIT-2.0.3 && \
  make && \
  make install && \
  cd /tmp/src/lua-cjson-2.1.0 && \
  make LUA_INCLUDE_DIR=/usr/local/include/luajit-2.0 && \
  make install && \
  cd /tmp/src/lua-resty-string-0.09 && \
  make install && \
  cd /tmp/src/nginx-1.7.4 && \
  ./configure \
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_gzip_static_module \
    --with-http_realip_module \
    --with-http_spdy_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-cc-opt=-I/usr/include/ossp \
    --with-ld-opt=-lossp-uuid \
    --add-module=/tmp/src/ngx_devel_kit-0.2.19 \
    --add-module=/tmp/src/lua-nginx-module-0.9.10 \
    --add-module=/tmp/src/nginx-openssl-version-0.04 \
    --add-module=/tmp/src/nginx-x-rid-header-92f9a11dec1cae56d287ab0a9c826206606d4e0b \
    --add-module=/tmp/src/headers-more-nginx-module-0.25 && \
  make && \
  make install && \
  cd / && \
  ldconfig && \
  rm -rf /tmp/src && \
  rm -rf /usr/local/nginx/conf && \
  rm -rf /usr/local/nginx/html && \
  chown -R nobody:nogroup /usr/local

ADD conf /usr/local/nginx/conf
ADD confd /usr/local/etc/confd
ADD bin/confd-nginx /usr/local/bin/confd-nginx

ENV PATH /usr/local/nginx/sbin:$PATH

EXPOSE 8000
ENTRYPOINT ["confd-nginx"]
CMD []
