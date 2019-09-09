# seminaria

Open source software in ruby on rails for managing university seminars. 

Authentication integrated with omniauth.

Internal users (professors, phd students etc.) can promote seminars and ask for speaker repayments.

The seminars shedule is public with many different views 
(possibile aggregation by location, arguments, organization...).

## Requirements

*  Rails 5
*  Ruby 2.6+

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
docker-compose run web bundle exec bin/docker_setup
docker-compose up
```

the configuration in docker comes from 

  - `doc/dm_unibo_common_docker.yml` that sets the omniauth_provider as :developer so that you are logged ad first user (see [https://github.com/donapieppo/dm_unibo_common] and [https://github.com/donapieppo/dm_unibo_common/blob/master/app/controllers/logins_controller.rb] for details on developer mode).
  - `doc/docker_seeds.rb` where two organizations (Math and Chimica) and three users (administrator@example.com manager@example.com and user@example.com) are created
  - `doc/seminaria_example.rb` where user administrator@example.com is configured ad main administrator.

In production of course you have to configure a correct omniauth provider.

When connected to http://127.0.0.1:3000/ you are logged as administrator@example.com on the first organization (Math).

### For developers

#### Authorizations

The table is *permissions* (class Permission < ApplicationRecord)

```sql
+-----------------+------------------+------+-----+---------+----------------+
| Field           | Type             | Null | Key | Default | Extra          |
+-----------------+------------------+------+-----+---------+----------------+
| id              | int(10) unsigned | NO   | PRI | NULL    | auto_increment |
| user_id         | int(10) unsigned | NO   | MUL | NULL    |                |
| organization_id | int(10) unsigned | NO   | MUL | NULL    |                |
| authlevel       | int(2)           | YES  |     | NULL    |                |
+-----------------+------------------+------+-----+---------+----------------+
```

and the "interpretation of the permissions" is class Authorization.

Current user (current_user as usual for omniauth and devide) 
has an authorization attribute (see app/controller/application_controller.rb in 
before_action :retrive_authlevels).

Actually there are 3 authorization levels.

  - TO_READ   = 1
  - TO_MANAGE = 2
  - TO_CESIA  = 3




