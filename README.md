# ControverSciences

## Get ControverSciences up and running for developpement on Linux

### Clone the repository and cd to the dir

```
$ git clone https://github.com/ThibaultLatrille/ControverSciences.git
$ cd /ControverSciences
```

### Install RVM for managing ruby version

Follow steps in
https://rvm.io/

ControverSciences is currently using ruby 2.1.2

### Install PostgreSQL 9.4 and create role

Install the Postgresql libraries:

```
$ sudo apt-get install postgresql-9.4
$ sudo apt-get install libpq-dev
```

Then create the user (AKA "role") inside PostgreSQL:

```
$ psql -d postgres
postgres=# create role controversciences login createdb password 'password';
postgres=# \q
```


### Install the gems

```
$ bundle install
```

### Create database and populate with Fake data

```
$ rake db:create
$ sh ./dump/pg_restore
```

If you get an error at this step, as the following:

```
could not connect to server: Connection refused Is the server running on host "localhost" (::1) and accepting TCP/IP connections on port 5432?
could not connect to server: Connection refused Is the server running on host "localhost" (127.0.0.1) and accepting TCP/IP connections on port 5432? 
```

It may be because the postgresql port is not well defined. Please check in the config file `/etc/postgresql/9.4/main/postgresql.conf` that `port=5432`.

### Run local webserver

```
$ rails s
```

Navigate to 127.0.0.1:3000 with your favorite browser and you are Up & Running

## Repopulate the database after a maj or if you screwed the database

```
$ rake db:drop db:create
$ sh ./dump/pg_restore
```

### Connect as an admin of the website in the local version

* Login : administrator@controversciences.org
* Password: 'password'

### Authors

Thibault Latrille

### Licence

The MIT License (MIT)

Copyright (c) 2015 the authors

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
