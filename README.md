# seminaria

Open source software in ruby on rails for managing university seminars. 

Authentication integrated with omniauth.

Internal users (professors, phd students etc.) can promote seminars and ask for speaker repayments.

The seminars shedule is public with many different views 
(possibile aggregation by location, arguments, organization...).


## Requirements

*  Rails 5
*  Ruby 2.3+

## Installation

Clone the repository and 

```bash
    $ cd seminaria
    $ bundle
    $ cp doc/dm_unibo_common.yml config/dm_unibo_common.yaml
    $ cp doc/seminaria_example.rb config/initializers/seminaria.rb
```

Then edit `config/dm_unibo_common.yaml` and `config/initializers/seminaria.rb` to configure your installation. 

In `config/database.yml` configure database and username and set the database password
in your environment as SEMINARIA_DATABASE_PASSWORD.

Then

    $ rake db:schema:load

to load che db schema (default with mysql but you can change db
settings in `config/database.yml` file)

## Docker for first try

```bash
docker-compose build
docker-compose run --rm web bundle exec bin/setup
docker-compose run web
```

the configuration in docker comes from 

  - `doc/dm_unibo_common_docker.yml` that sets the omniauth_provider as :developer so that you are logged ad first user (see [https://github.com/donapieppo/dm_unibo_common] and [https://github.com/donapieppo/dm_unibo_common/blob/master/app/controllers/logins_controller.rb] for details on developer mode).
  - `doc/docker_seeds.rb` where two organizations (Math and Chimica) and two users (admin.name@example.com and user.example@example.com) are created
  - `doc/seminaria_example.rb` where user admin.name@example.com is configured ad main administrator.

In production of course you have to configure a correct omniauth provider.




