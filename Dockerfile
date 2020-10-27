FROM ruby:2.6.3

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update && apt-get install -y build-essential libpq-dev nodejs postgresql-client
RUN gem update --system 2.7.8

# https://www.elastic.co/guide/en/beats/filebeat/current/setup-repositories.html#_apt
RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
RUN echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list
RUN apt-get update && apt-get install filebeat -y
COPY docker-compose/filebeat/filebeat.yml /etc/filebeat/
RUN update-rc.d filebeat defaults 95 10


COPY Gemfile* /
RUN bundle install

RUN mkdir /src
COPY . /src

CMD service filebeat start && rm -f /src/tmp/pids/server.pid && cd src && rails server -p 5000 -b '0.0.0.0'