FROM ruby:3.0.7-slim
ENV LANG C.UTF-8

# 基本ツール + mysql2 ビルド用ライブラリ
RUN apt-get update -qq \
 && apt-get install -y --no-install-recommends \
    curl \
    git \
    default-libmysqlclient-dev \
    xz-utils \
    build-essential \
 && curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
 && apt-get install -y --no-install-recommends \
    nodejs \
 && rm -rf /var/lib/apt/lists/*

RUN gem install bundler -v 2.4.22

WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install

ENV APP_HOME /myapp
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
ADD . $APP_HOME
