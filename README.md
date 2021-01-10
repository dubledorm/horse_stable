# README

##Развёртывание через docker-compose
### Общее
* В файле docker-compose.yml подключаем БД и redis
* Рядом с файлом docker-compose.yml кладём файл файл .env В нём прописываем переменные окружения типа паролей и прочего. Этот файл не сохраняем в git
* Для инициализации БД рядом кладём файл init.sql. Он автоматически запускается при разворачивании postgres. Выполняется один раз. В нём имеет смысл определить пользователя и создать БД
* Дальнейшая инициализация приложения выполняется через rake db:migration и rake db:seed
* Важно - переменные окружения, объявленнные в файле .env должны явно определяться в docker-compose.yml следующим образом:


    DATABASE_URL: ${DATABASE_URL}
* База данных хранится на локальном диске хоста. Делается это через подключенный том db_data

### Пример файла docker-compose.yml
    
    version: '3.4'
    
    services:
    horse_stable:
    build:
    context: ./horse_stable
    dockerfile: Dockerfile
    image: selenium_horse_stable
    depends_on:
    - redis
    - database
    ports:
    - "3000:3000"
    volumes:
    - /var/log/simple_project:/app/log
    
        environment:
          RAILS_ENV: 'production'
          RACK_ENV: 'production'
          RAILS_SERVE_STATIC_FILES: 'true'
          REDIS_URL: 'redis://redis:6379/1'
          DATABASE_URL: ${DATABASE_URL}
    
    database:
    image: postgres:12.1
    volumes:
    - db_data:/var/lib/postgresql/data
    - ./init.sql:/docker-entrypoint-initdb.d/init.sql
    
    redis:
      image: redis:5.0.7
    
    
    volumes:
    db_data:
    

### Пример init.sql

    CREATE USER horse_stable_prod;
    ALTER USER horse_stable_prod WITH SUPERUSER;
    CREATE DATABASE horse_stable_production;

### Пример файла .env
    SECRET_KEY_BASE=8b56cec9a10d0cf5423c191503a70f434f6371a81f2409959d696a3ff2313b63d0ae46ae0632a088dc28709a2dec833dab6ca224e32118201e4a3b3ab4ef717d
    DATABASE_URL=postgres://horse_stable_prod@database/horse_stable_production
    SENDMAIL_USERNAME=user_name
    SENDMAIL_PASSWORD=password


## Порядок действий при развёртывании системы на новом хосте.
Предполагаем, что на хосте совсем ничего нет

* Завести нового пользователя и выдать ему права на sudo. Инструкция здесь: https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-18-04
* Установить docker (не устанавливается на серверах vps. только vds). Инструкция здесь: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04
* Установить docker-compose. Инструкция здесь: https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-ubuntu-18-04-ru
* Создать отдельную папку под проект. Скопировать в неё docker-compose.yml, init.sql, .env. Исправить параметры в последних двух файлах.
Для docker-compose.yml приходится отключать секцию build для horse-stable и оставлять только image. Иначе пытается собирать проект.
  Команда для копирования:
  

    scp docker-compose.yml  azirumga@92.63.193.31:/home/azirumga/selenium/docker-compose.yml
* Собрать на компе с исходниками образ. Например через docker-compose


    docker-compose build
* Записать образ в файл


    docker save -o selenium_horse_stable.tar selenium_horse_stable
* Скопировать файл на собираемую машину через scp. Здесь развернуть его командой:


    sudo docker load -i selenium_horse_stable.tar
* Теперь запускаем приложение с помощью команды:


    sudo docker-compose up -d
* Должны запуститься база данных, редис и приложение. В этот момент должен быть выполнен init.sql и создаться пользователь и БД.
Можно проверить это, подключившись черех psql


    azirumga@dubledorm2:~/selenium$ sudo docker-compose exec database psql -U postgres
    psql (12.1 (Debian 12.1-1.pgdg100+1))
    Type "help" for help.
    
    postgres=# \l
    List of databases
    Name           |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
    -------------------------+----------+----------+------------+------------+-----------------------
    horse_stable_production | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
    postgres                | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
    template0               | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
    |          |          |            |            | postgres=CTc/postgres
    template1               | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
    |          |          |            |            | postgres=CTc/postgres
    (4 rows)
    
    postgres=# \du
    List of roles
    Role name     |                         Attributes                         | Member of
    -------------------+------------------------------------------------------------+-----------
    horse_stable_prod | Superuser                                                  | {}
    postgres          | Superuser, Create role, Create DB, Replication, Bypass RLS | {}


* Далее выполняем команды:


    sudo docker-compose exec horse_stable bundle exec rake db:migrate
    sudo docker-compose exec horse_stable bundle exec rake db:seed

     