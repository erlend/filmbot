FROM ruby:2.3-alpine

EXPOSE 3000

ENV RAILS_LOG_TO_STDOUT=enabled \
    RAILS_SERVE_STATIC_FILES=enabled \
    RAILS_ENV=production

COPY . /app/
WORKDIR /app

RUN apk add -U nodejs alpine-sdk postgresql-dev postgresql-libs tzdata && \
    bundle install --deployment --without="development test" && \
    bin/rake assets:precompile && \
    apk del alpine-sdk postgresql-dev && \
    gem install foreman --no-document && \
    adduser -D app && \
    rm -rf /var/tmp/*/ /tmp/*/ /var/cache/apk/*

USER app
CMD bin/rails server -b 0.0.0.0
