# ControverSciences

## Get ControverSciences up and running for developpement on Linux

### Clone the repository and cd to the dir

```
git clone https://github.com/ThibaultLatrille/ControverSciences.git
cd ControverSciences
```

### Install RVM for managing ruby version

Follow steps in
[https://rvm.io/](https://rvm.io/)

Don't forget to append '--rails --ruby' for a all in one installation

ControverSciences is currently using ruby 2.5.6
```
rvm install 2.7.3
rvm use 2.7.3
gem install bundler
```

### Install PostgreSQL and create role

Install the Postgresql libraries:

```
sudo apt-get install postgresql
sudo apt-get install libpq-dev
```

Then create the user (AKA "role") inside PostgreSQL:

```
sudo su - postgres
psql -d postgres
postgres=# create role controversciences login superuser password 'password';
postgres=# \q
```


### Install the gems

```
bundle install
```

### Create database and populate with anonymized data
```
rake db:create
sh ./dump/pg_restore
```
The password is as defined above during role creation: 'password'

### Run local webserver

```
rails s
```

Navigate to 127.0.0.1:3000 with your favorite browser and you are Up & Running

## Repopulate the database after a maj or if you screwed the database

```
rake db:drop db:create
sh ./dump/pg_restore
```

### Connect as an admin of the website in the local version

* Login : administrator@controversciences.org
* Password: 'password'

### Authors

Thibault Latrille

### Licence

The MIT License (MIT)

Copyright (c) 2015 Thibault Latrille

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
