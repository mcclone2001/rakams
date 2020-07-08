FROM ruby:2.6.3

COPY Gemfile* /
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update && apt-get install -y build-essential libpq-dev nodejs postgresql-client
RUN gem update --system 2.7.8
RUN bundle install

RUN mkdir /src
COPY . /src

CMD cd src && rails server -p 5000 -b '0.0.0.0'