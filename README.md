# King-Tide-API  

[![Build Status](https://travis-ci.org/alexsaldana9/king-tide-api.svg?branch=master)](https://travis-ci.org/alexsaldana9/king-tide-api)



## Dependencies    

    - Ruby version - ruby 2.5.0
    - postgres 
    - sqlite

## How to run the app    

```bash
$ rails s
```

When dependencies or the database change run this 

```bash
$ bundle install
$ rails db:create
$ rails db:migrate
$ rails db:seed
```


## How to run migrations in heroku  

log into heroku, and run the command below in the online heroku console

```bash
$ rails db:migrate
```

## Add a secret key to heroku  

```bash
$ rails runner "SecretKey.create(name: 'KEY_NAME', key: 'SECRET KEY')"
```
    
## Delete a secret key from heroku    

```bash
$ rails runner "SecretKey.where(name: 'KEY_NAME').destroy_all"
```

## How to run the tests  

```bash
$ rails spec
```
When the database changes, you need to change the Test database.

```bash
$ RAILS_ENV=test rails db:drop
$ RAILS_ENV=test rails db:create
$ RAILS_ENV=test rails db:migrate
```

## Annotate the models  

```bash
$ bundle exec rake annotate_models
```

[What is annotate?](https://github.com/ctran/annotate_models)  

## Deployment instructions  

```bash
$ git push origin master
```
   
Deployment is in Heroku, and build is in Travis CI. Once the bill is OK, then it is deployed to Heroku automatically.
