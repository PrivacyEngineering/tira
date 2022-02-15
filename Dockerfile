FROM ruby:2.6.3-buster

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN apt-get update &&\
  apt-get install git libpq-dev build-essential nodejs -y &&\
  gem install pg &&\
  gem install bundler &&\
  bundle install

COPY . .

EXPOSE 3000
CMD ["bundle", "exec", "rails","s", "-b","0.0.0.0", "-p", "3000"]