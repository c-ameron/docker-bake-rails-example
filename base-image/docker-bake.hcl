group "default" {
    targets = ["build","runtime"]
}

variable "RUBY_VERSION" {
  default = "$RUBY_VERSION"
}

variable "DATABASE" {
  default = "$DATABASE"
}

target "build" {
    contexts = {
        ruby-alpine = "docker-image://ruby:${RUBY_VERSION}-alpine"
    }
    args = {
        BUILDTIME_DEPS = "${DATABASE}-base-build-deps"
        RUNTIME_DEPS = "${DATABASE}-base-runtime-deps"
    }
    dockerfile = "base-ruby-build.Dockerfile"
    pull = true
    platforms = ["linux/amd64","linux/arm64"]
    tags = [
        "cgza/base-ruby-build:${RUBY_VERSION}-${DATABASE}",
        "cgza/base-ruby-build:${RUBY_VERSION}-${DATABASE}-${formatdate("YYYYMMDD",timestamp())}"
        ]
}

target "runtime" {
    contexts = {
        ruby-alpine = "docker-image://ruby:${RUBY_VERSION}-alpine"
    }
    args = {
        RUNTIME_DEPS = "${DATABASE}-base-runtime-deps"
    }
    dockerfile = "base-ruby-runtime.Dockerfile"
    pull = true
    platforms = ["linux/amd64","linux/arm64"]
    tags = [
        "cgza/base-ruby-runtime:${RUBY_VERSION}-${DATABASE}",
        "cgza/base-ruby-runtime:${RUBY_VERSION}-${DATABASE}-${formatdate("YYYYMMDD",timestamp())}"
        ]
}
