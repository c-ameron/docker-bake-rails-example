FROM ruby-alpine
ENV LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=C.UTF-8 LC_CTYPE=C.UTF-8
ARG BUILDTIME_DEPS
ARG RUNTIME_DEPS
COPY $BUILDTIME_DEPS /tmp/
COPY $RUNTIME_DEPS /tmp/
RUN apk -U upgrade && \
    cat /tmp/$BUILDTIME_DEPS | xargs apk add --no-cache && \
    cat /tmp/$RUNTIME_DEPS | xargs apk add --no-cache && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /app && chown -R nobody:nogroup /app
WORKDIR /app
