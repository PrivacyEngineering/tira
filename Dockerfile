FROM ruby:2.6.3-buster

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN sed -i 's|deb.debian.org/debian|archive.debian.org/debian|g' /etc/apt/sources.list &&\
  sed -i 's|security.debian.org/debian-security|archive.debian.org/debian-security|g' /etc/apt/sources.list &&\
  sed -i '/buster-updates/d' /etc/apt/sources.list &&\
  apt-get -o Acquire::Check-Valid-Until=false update &&\
  apt-get install git libpq-dev build-essential nodejs -y &&\
  gem install bundler:2.2.14 &&\
  bundle install

COPY . .

EXPOSE 3000
CMD ["bundle", "exec", "rails","s", "-b","0.0.0.0", "-p", "3000"]