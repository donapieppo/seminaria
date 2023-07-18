FROM ruby:3.2 AS donapieppo_ruby
MAINTAINER Donapieppo <donapieppo@yahoo.it>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -yq --no-install-recommends build-essential gnupg2 curl git vim locales libvips \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -

RUN apt-get update \
    && apt-get install -yq nodejs \
    && apt-get clean
 
RUN npm install -g yarn

FROM donapieppo_ruby AS donapieppo_seminaria

WORKDIR /app
COPY Gemfile* ./
RUN bundle install
COPY . .

# configuration
RUN ["/bin/cp", "doc/docker_database.yml",        "config/database.yml"]
RUN ["/bin/cp", "doc/dm_unibo_common_docker.yml", "config/dm_unibo_common.yml"]
RUN ["/bin/cp", "doc/seminaria_example.rb",       "config/initializers/seminaria.rb"]
RUN ["/bin/cp", "doc/docker_seeds.rb",            "db/seeds.rb"]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
