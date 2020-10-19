# Vtiger7 docker container

Vtiger docker container mostly based on [https://github.com/pimuzzo/vtiger](https://github.com/pimuzzo/vtiger)

## Build

```
docker build . -t vtiger
```

Or you can use directly our image `adiandev/vtiger`

## Usage

You will need mysql with a special configuration this is on the project folder examples/mysql.conf.d

Run the mysql container:

```
docker run --name mysql -d -v $(PWD)/examples/mysql.conf.d -e MYSQL_ROOT_PASSWORD=1234 -e MYSQL_DATABASE=vtiger -e MYSQL_USER=vtiger -e MYSQL_PASSWORD=1234 mysql
```

Run the vtiger container:

```
docker run --name vtiger -d --link mysql -e DB_HOSTNAME=mysql -e DB_USERNAME=vtiger -e DB_PASSWORD=1234 -e DB_NAME=vtiger -p 8080:80 adiandev/vtiger
```

Then, vtiger will be running on [http://localhost:8080](http://localhost:8080).

## Usage (docker compose)

```
version: '3.5'
services:
  vtiger:
    image: adiandev/vtiger
    environment:
      DB_HOSTNAME: db
      DB_NAME: vtiger
      DB_USERNAME: vtiger
      DB_PASSWORD: 1234
    ports:
      - "8080:80"
    volumes:
      - "vtigervol:/var/www/html"
    links:
      - db
  db:
    image: mysql
    environment:
      MYSQL_RANDOM_ROOT_PASSWORD: "true"
      MYSQL_DATABASE: vtiger
      MYSQL_USER: vtiger
      MYSQL_PASSWORD: 1234
    volumes:
      - "${MYSQL_CONF_FOLDER}:/etc/mysql/conf.d"
      - "dbvol:/var/lib/mysql"

volumes:
  dbvol:
  vtigervol:
```

Then, vtiger will be running on [http://localhost:8080](http://localhost:8080).

## Environment variables

+ DB_HOSTNAME (Required): The ip address or domain where is your database server.
+ DB_PORT (Optional): Port where the database server is listening (3306 by default).
+ DB_NAME (Required): Database name.
+ DB_USERNAME (Required): Database user.
+ DB_PASSWORD (Required): Database user password.

## Behind reverse proxy

If this container is running behind a reverse proxy that puts https over the connection you must
add a special config to your reverse proxy in order to have a working connection.

The proxy must set the header "Referer" to a http url, example:

```
Referer="http://vtiger.example.com"
```

This solution es thanks to mikydevel at: [https://discussions.vtiger.com/discussion/189604/vtiger-behind-reverse-proxy]().

