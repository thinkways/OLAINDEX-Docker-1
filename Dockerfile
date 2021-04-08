FROM trafex/alpine-nginx-php7

USER root

WORKDIR /var/www

RUN apk update && apk add git

RUN apk update && apk add composer php7-bcmath php7-pdo php7-fileinfo \
        php7-tokenizer php7-xmlwriter php7-sqlite3 php7-pdo_sqlite

USER root

RUN git clone https://github.com/WangNingkai/OLAINDEX.git tmp
RUN mv tmp/.git .
RUN rm -rf tmp
RUN git reset --hard
RUN rm -rf html
RUN ln -s public html

RUN sed -i "s?\$proxies;?\$proxies=\'\*\*\';?" /var/www/app/Http/Middleware/TrustProxies.php

ENV COMPOSER_ALLOW_SUPERUSER=1
RUN composer install -vvv
RUN chmod -R 777 storage
RUN chown -R www:www * 
RUN composer run install-app

RUN chown -R nobody.nobody /var/www && \
  chown -R nobody.nobody /run && \
  chown -R nobody.nobody /var/lib/nginx && \
  chown -R nobody.nobody /var/log/nginx 

RUN apk del git

RUN sed -i 's/jpg|jpeg|gif|png|//' /etc/nginx/nginx.conf

USER nobody

RUN * * * * * php artisan schedule:run >> /dev/null 2>&1 &
