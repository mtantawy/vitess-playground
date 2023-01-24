FROM ruby:3.2

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install
# https://github.com/Shopify/bootsnap#precompilation
RUN bundle exec bootsnap precompile --gemfile app/ lib/

COPY . .

CMD [ "bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000" ]
