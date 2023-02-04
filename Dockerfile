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

# Install composer:
RUN wget https://raw.githubusercontent.com/composer/getcomposer.org/1b137f8bf6db3e79a38a5bc45324414a6b1f9df2/web/installer -O - -q | php -- --quiet
RUN mv composer.phar /usr/local/bin/composer

RUN mkdir -p /home/winpc/test/laravelApp/app
WORKDIR /home/winpc/test/laravelApp/app

COPY composer.json /home/winpc/test/laravelApp/app
RUN composer install

COPY . /home/winpc/test/laravelApp/app

RUN php artisan db:seed
RUN php artisan key:generate

CMD php artisan migrate
ENTRYPOINT php artisan serve --host 0.0.0.0 --port 5001

