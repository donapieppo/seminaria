FROM ruby:3.2 AS donapieppo_ruby
MAINTAINER Donapieppo <donapieppo@yahoo.it>

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /app

ARG UID=1000
ARG GID=1000

RUN apt-get update \
    && apt-get install -yq --no-install-recommends build-essential gnupg2 curl git vim locales libvips libmariadb-dev

RUN curl -sL https://deb.nodesource.com/setup_20.x | bash -

RUN apt-get update \
    && apt-get install -yq --no-install-recommends nodejs \
    && npm install -g yarn \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
    && groupadd -g ${GID} ruby \
    && useradd --create-home --no-log-init -u ${UID} -g ${GID} ruby \
    && chown ruby:ruby -R /app
 
FROM donapieppo_ruby AS donapieppo_seminaria_bundle

USER ruby

COPY --chown=ruby:ruby Gemfile Gemfile.lock package.json yarn.lock ./

RUN bundle install
RUN yarn install

FROM donapieppo_seminaria_bundle AS donapieppo_seminaria

COPY --chown=ruby:ruby . .

# configuration
RUN ["/bin/cp", "doc/docker_database.yml",        "config/database.yml"]
RUN ["/bin/cp", "doc/docker_omniauth.rb",         "config/initializers/omniauth.rb"]
RUN ["/bin/cp", "doc/dm_unibo_common_docker.yml", "config/dm_unibo_common.yml"]
RUN ["/bin/cp", "doc/seminaria_example.rb",       "config/initializers/seminaria.rb"]
RUN ["/bin/cp", "doc/docker_seeds.rb",            "db/seeds.rb"]

RUN ./bin/rails assets:precompile

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
