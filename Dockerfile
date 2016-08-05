FROM ruby:2.3
MAINTAINER Donapieppo <donapieppo@yahoo.it>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y -y --no-install-recommends mysql-client \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install
COPY . .

# configuration
RUN ["/bin/cp", "doc/dm_unibo_common_docker.yml",  "config/dm_unibo_common.yml"]
RUN ["/bin/cp", "doc/seminaria_example_docker.rb", "config/initializers/seminaria.rb"]
RUN ["/bin/cp", "doc/docker_database.yml",         "config/database.yml"]

# db
RUN ["rake", "db:create"]
RUN ["rake", "db:schema:load"]

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]



