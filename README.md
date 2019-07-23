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

## Docker as alternative

```bash
docker-compose build
docker-compose run --rm web bundle exec bin/setup
docker-compose run web
```

