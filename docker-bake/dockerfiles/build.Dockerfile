# This isn't built as a base image, but instead sourced as additional build instructions in docker-bake.hcl
FROM base-build-ruby

ARG BUNDLE_WITHOUT="development:test"
ENV BUNDLE_WITHOUT=$BUNDLE_WITHOUT
COPY --from=local .build-deps /tmp/
COPY --from=local .runtime-deps /tmp/
COPY --from=local .ruby-version /app/
COPY --from=local Gemfile* /app/
ARG BUNDLE_INSTALL="true"
RUN --mount=type=secret,id=BUNDLE_GITHUB__COM \
    export BUNDLE_GITHUB__COM="$(cat /run/secrets/BUNDLE_GITHUB__COM)" && \
    apk -U upgrade && \
    cat /tmp/.build-deps | xargs apk add --no-cache && \
    cat /tmp/.runtime-deps | xargs apk add --no-cache && \
    rm -rf /var/cache/apk/* && \
    gem update --system && \
    if [ $BUNDLE_INSTALL == "true" ]; then \
    bundle install --jobs 20 --retry 5 ; fi
