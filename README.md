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
