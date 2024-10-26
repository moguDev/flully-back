FROM ruby:3.3.3
RUN apt-get update -qq && apt-get install -y vim 

RUN mkdir /usr/src/app 
WORKDIR /usr/src/app
COPY Gemfile /usr/src/app/Gemfile 
COPY Gemfile.lock /usr/src/app/Gemfile.lock 

RUN gem update --system 
RUN bundle update --bundler 

RUN bundle install 
COPY . /usr/src/app 

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh 
ENTRYPOINT ["entrypoint.sh"]