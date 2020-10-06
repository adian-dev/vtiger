FROM php:7.4-apache

COPY entrypoint.sh /

RUN curl -SL https://downloads.sourceforge.net/project/vtigercrm/vtiger%20CRM%207.3.0/Core%20Product/vtigercrm7.3.0.tar.gz \
	| tar -C / -xz \
	&& apt update \
	&& apt install -y libxml2-dev libssl-dev libc-client2007e-dev libkrb5-dev libcurl4-openssl-dev libcurl4-openssl-dev \
    && docker-php-ext-configure imap --with-imap-ssl --with-kerberos \
	&& docker-php-ext-install imap curl xml mysqli \
	&& sh -c "\
        echo 'display_errors=Off'; \
        echo 'memory_limit=256M'; \
        echo 'max_execution_time=60'; \
        echo 'error_reporting=E_WARNING & ~E_NOTICE & ~E_DEPRECATED'; \
        echo 'log_errors=Off'; \
        echo 'short_open_tag=Off'; " > $PHP_INI_DIR/conf.d/vtiger-recommended.ini \
	&& mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
	&& chmod +x /entrypoint.sh


ENTRYPOINT ["/entrypoint.sh"]

CMD ["apache2-foreground"]

