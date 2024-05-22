FROM ubuntu:latest

#password for mysql authentication
ENV MYSQL_ROOT_PASSWORD=${DB_PASSWORD}

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y apache2 \
                       mysql-server \
                       php \
                       php-mysql \
                       libapache2-mod-php \
                       php-xml \
                       php-mbstring \
                       libicu-dev \
                       wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy custom MySQL configuration file to allow remote connections
COPY my.cnf /etc/mysql/mysql.conf.d/mysqld.cnf

ENV LD_LIBRARY_PATH="/opt/icu/lib"

# Download and extract MediaWiki
WORKDIR /tmp/
RUN wget https://releases.wikimedia.org/mediawiki/1.41/mediawiki-1.41.1.tar.gz && \
    tar -xvzf mediawiki-*.tar.gz && \
    mkdir /var/lib/mediawiki && \
    mv mediawiki-*/* /var/lib/mediawiki && \
    rm mediawiki-*.tar.gz

# Initialize MySQL database and set root password
RUN mysqld_safe --skip-networking & \
    sleep 10 && \
    mysqladmin --silent --wait=30 ping || exit 1 && \
    mysql -uroot --execute="ALTER USER 'root'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY '${MYSQL_ROOT_PASSWORD}'; FLUSH PRIVILEGES;" && \
    mysql -uroot -p${MYSQL_ROOT_PASSWORD} --execute="DELETE FROM mysql.user WHERE User='';" && \
    mysql -uroot -p${MYSQL_ROOT_PASSWORD} --execute="DROP DATABASE IF EXISTS test;" && \
    mysql -uroot -p${MYSQL_ROOT_PASSWORD} --execute="DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';" && \
    mysql -uroot -p${MYSQL_ROOT_PASSWORD} --execute="CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';" && \
    mysql -uroot -p${MYSQL_ROOT_PASSWORD} --execute="GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;" && \
    mysql -uroot -p${MYSQL_ROOT_PASSWORD} --execute="FLUSH PRIVILEGES;" && \
    mysql -uroot -p${MYSQL_ROOT_PASSWORD} --execute="create database mediawiki;" && \
    mysqladmin -uroot -p${MYSQL_ROOT_PASSWORD} shutdown

EXPOSE 80

RUN sed -i 's/^\(upload_max_filesize = \).*/\120M/' /etc/php/8.3/apache2/php.ini

RUN ln -s /var/lib/mediawiki /var/www/html/mediawiki


RUN apt-get update -y && \
    apt-get install -y php-intl

CMD bash -c 'service mysql start && apache2ctl -D FOREGROUND'
