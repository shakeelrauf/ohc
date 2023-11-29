# syntax=docker/dockerfile:1.4

FROM phusion/passenger-ruby30
# How many bundler jobs to run in parallel - set with --build-arg="BUNDLER_JOBS=2"
ARG BUNDLER_JOBS=1

# Note: This Dockerfile is roughly in reverse order of likelihood to change for performance (so cached layers
#       at the bottom of the stack can be re-used rather than rebuilt)

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# Install public keys for hosts
RUN mkdir -p -m 0600 /home/app/.ssh \
  && ssh-keyscan bitbucket.org >> /home/app/.ssh/known_hosts 

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
  imagemagick ffmpeg \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /home/app/webapp/tmp \
  && truncate -s 0 /var/log/*log

# Start Nginx / Passenger and remove the default site
RUN rm -f /etc/service/nginx/down \
  && rm /etc/nginx/sites-enabled/default

# COPY the nginx site and config
COPY docker/nginx.conf /etc/nginx/sites-enabled/webapp.conf
COPY docker/rails-env.conf /etc/nginx/main.d/rails-env.conf

# Update Bundler to version specified in Gemfile.lock
RUN gem install bundler -v 2.3.25

# Switch to app user - which runs the application process - to bundle install
USER app:app
# Set HOME env var used by bundler to store bundle and config files
ENV HOME /home/app

# Copy Gemfiles for bundler to use to install bundle
# Note: We copy the Gemfile over and install the bundle ahead of the app source files because they're less
#       likely to change, so we can use them as cached layers for subsequent builds
COPY --chown=app:app Gemfile Gemfile.lock /tmp/
COPY --chown=app:app vendor/cache /tmp/vendor/cache
WORKDIR /tmp

# Mount the ssh-agent from the host for the app user (uid: 9999) and install the bundle
RUN --mount=type=ssh,uid=9999 bundle config path /home/app/.bundle \
  && bundle install --jobs $BUNDLER_JOBS

# COPY the Rails app - See .dockerignore file for what is excluded from being copied into the image
COPY --chown=app:app . /home/app/webapp/

# Compile assets and remove temp files
WORKDIR /home/app/webapp
RUN bundle exec rake assets:precompile \
  && rm -rf ./tmp/*

# Switch back to root user, because base image requires it to correctly run
# See: https://github.com/phusion/passenger-docker/issues/250
USER root
