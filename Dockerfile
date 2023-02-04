FROM php:7-apache
LABEL MAINTAINER babadeen

RUN apt update
RUN apt install zip git nginx -y
RUN docker-php-ext-install pdo_mysql mysqli
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html

COPY . .
RUN mv /var/www/html/.env.sample /var/www/html/.env
RUN chmod +x artisan

RUN composer install
RUN php artisan db:seed
RUN php artisan key:generate

CMD php artisan migrate
ENTRYPOINT php artisan serve --host 0.0.0.0 --port 5001
