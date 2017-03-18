FROM ruby:2.3-alpine

EXPOSE 3000
VOLUME /app/db

ENV RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=true \
    RAILS_ENV=production

COPY . /app/
WORKDIR /app

RUN apk add -U nodejs alpine-sdk sqlite-dev sqlite-libs tzdata && \
    bundle install --deployment --without="development test" && \
    bin/rake assets:precompile && \
    apk del alpine-sdk sqlite-dev && \
    rm -rf /var/tmp/*/ /tmp/*/ /var/cache/apk/*

CMD bin/rails server -b 0.0.0.0
