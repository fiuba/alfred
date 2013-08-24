Alfred
======

[![Build Status](https://travis-ci.org/fiuba/alfred.png?branch=develop)](https://travis-ci.org/fiuba/alfred)

After cloning the repository:

* Install dependencies: **_bundle install_**
* Run tests: **_bundle exec rake_**
* Create the database: **_PADRINO_ENV=development bundle exec rake db:migrate_**
* Populate the database: **_PADRINO_ENV=development bundle exec rake db:seed_**
* Run the application: **_bundle exec padrino start_**

Note: the current implementation depends on Dropbox to store assignments files, so the following environment variables must be set:
* DROPBOX_APP_KEY
* DROPBOX_APP_SECRET
* DROPBOX_REQUEST_TOKEN_KEY
* DROPBOX_REQUEST_TOKEN_SECRET
* DROPBOX_AUTH_TOKEN_KEY
* DROPBOX_AUTH_TOKEN_SECRET


After performing these steps you can use the following users to log into the application:

* teacher@test.com, Passw0rd!
* student@test.com, Passw0rd!
*

Private documentation is available [here](https://drive.google.com/folderview?id=0BwxS5GYrNYTqcjkzUUVxMk1ia2c&usp=sharing).
