FROM base-runtime-ruby

USER root
ARG APP_NAME
ENV APP_NAME=$APP_NAME
ARG BUNDLE_WITHOUT="development:test"
ENV BUNDLE_WITHOUT=$BUNDLE_WITHOUT
COPY --from=local .runtime-deps /tmp/
RUN apk -U upgrade && \
    cat /tmp/.runtime-deps | xargs apk add --no-cache && \
    rm -rf /var/cache/apk/* && \
    gem update --system
USER nobody
COPY --from=build --chown=nobody /usr/local/bundle /usr/local/bundle
COPY --from=local --chown=nobody . /app/
CMD sh /app/bin/dispatch.sh
