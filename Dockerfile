FROM ubuntu:22.04

ENV NGINX_VERSION 1.22.1

# Instalando dependencias
RUN apt-get update
RUN apt-get install wget build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev -y

# Definindo pasta onde o nginx será compilado
WORKDIR /nginx

# Baixando código fonte
RUN wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz

# Extraindo...
RUN tar -zxvf nginx-${NGINX_VERSION}.tar.gz

# No caso do modulo que estaremos incluindo no nginx é necessário a seguinte dependencia...
# Poderia ser instalada no comando da linha 7, porém para deixar claro o que esta acontecendo, 
# irei instalar essa dependencia em um comando a parte.
RUN apt-get install libgd-dev -y

# Para verificar os modulos disponiveis rodar o comando './configure --help' dentro da pasta do arquivo 
# fonte do nginx que baixamos via wget

# Configurando...
RUN cd nginx-${NGINX_VERSION} ; \
    ./configure \
    --sbin-path=/usr/bin/nginx  \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --with-http_ssl_module \
    --with-pcre \
    # Adicionando modulos dinamicos
    --modules-path=/etc/nginx/modules \
    --with-http_image_filter_module=dynamic

# Complilando...
RUN cd nginx-${NGINX_VERSION} ; make

# Instalando...
RUN cd nginx-${NGINX_VERSION} ; make install

# Executa o processo do nginx
CMD ["nginx", "-g", "daemon off;"]
