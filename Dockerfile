FROM ruby:3.0.0-alpine3.13

ENV APP_ROOT /app
ENV BUNDLE_PATH /usr/local/bundle

RUN apk add --no-cache \
    bash \
    build-base \
    ghostscript-fonts \
    git \
    imagemagick \
    postgresql-dev \
    postgresql-client \
    less \
    tzdata

WORKDIR $APP_ROOT
COPY . $APP_ROOT

RUN bundle install --jobs 10

CMD ["bundle", "exec", "rails", "server"]
