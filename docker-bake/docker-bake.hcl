group "default" {
    targets = ["app"]
}

# a read only token to access the build and runtime dockerfiles
variable "GITHUB_RO_TOKEN" {
  default = "$GITHUB_RO_TOKEN"
}

# these are set as environment variables
variable "APP_IMAGE_TAG" {
  default = "$APP_IMAGE_TAG"
}

variable "APP_NAME" {
  default = "$APP_NAME"
}

target "build" {
    context = "https://${GITHUB_RO_TOKEN}@github.com/c-ameron/docker-bake-rails-example.git"
    contexts = {
        local = BAKE_CMD_CONTEXT # use the local path instead of the cloned repo for copying
    }
    secret = [
        # by default this will use local environment variables
        "type=env,id=BUNDLE_GITHUB__COM"
    ]
    dockerfile = "docker-bake/dockerfiles/build.Dockerfile"
}

target "runtime" {
    context = "https://${GITHUB_RO_TOKEN}@github.com/c-ameron/docker-bake-rails-example.git"
    contexts = {
        build = "target:build"
        local = BAKE_CMD_CONTEXT
    }
    args = {
        APP_NAME = "${APP_NAME}"
    }
    dockerfile = "docker-bake/dockerfiles/runtime.Dockerfile"
}



target "app" {
    context = BAKE_CMD_CONTEXT
    contexts = {
        app = "target:runtime"
    }
    dockerfile = "cwd://Dockerfile"
    tags = ["${APP_IMAGE_TAG}"]
}

# the setup for the dev image

group "dev" {
    targets = ["dev"]
}

target "build_dev" {
  inherits = ["build"]
  args = {
      BUNDLE_INSTALL = "false"
      BUNDLE_WITHOUT = ""
  }
}

target "dev" {
  inherits = ["app"]
  contexts = {
    app = "target:build_dev"
  }
    tags = ["${APP_NAME}:dev"]

    output = ["type=docker"]
}
