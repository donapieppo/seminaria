FROM ruby:2.3
MAINTAINER Donapieppo <donapieppo@yahoo.it>

ENV DEBIAN_FRONTEND noninteractive

ENV SECRET_KEY_BASE_SEMINARIA 2d32568r5e0e6b0f8adf3r01e09054b87fdaf8117eta673b901bd0ccdc24e12cf0ac3c948d7537befb929db833ef91b16ee90a494cd20cb6906541f9b6659761dkdkdk
ENV SEMINARIA_DATABASE_PASSWORD verysecuresecret

RUN apt-get update \
    && apt-get install -y -y --no-install-recommends sqlite3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install
COPY . .

# configuration
RUN ["/bin/cp", "doc/dm_unibo_common_docker.yml",  "config/dm_unibo_common.yml"]
RUN ["/bin/cp", "doc/seminaria_example_docker.rb", "config/initializers/seminaria.rb"]
RUN ["/bin/cp", "doc/sqlite_database.yml",         "config/database.yml"]

# db
RUN ["rake", "db:create"]
RUN ["rake", "db:schema:load"]

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]



