# One Hope Canada API

## Getting started

Clone the repo:

```bash
git clone git@bitbucket.org:dubitplatform/one-hope-canada-api.git one-hope-canada-api && cd one-hope-canada-api
```

Check out the `development` branch:

```bash
git checkout development
```

**Note:** At this point, you should switch to the development branch version of this Readme for the most up-to-date instructions.

## Installing and running the correct runtime

### Using Docker

#### Building the Docker container

The Dockerfile requires the `--ssh default` Docker Buildkit option to allow connecting your host machine's SSH agent to the Docker Daemon for the build process (in order to authenticate with Bitbucket for downloading the private repositories). Because Docker Compose [doesn't currently support this option](https://github.com/docker/compose/issues/7025) you need to build the Docker image using `docker build` separately:
                        
**Note:** You will need to rebuild the image every time you upgrade Ruby or change the gems in the bundle. This means it's likely good practice to build the docker image whenever you switch branches or commits.

```bash
# If your host machine has 4 CPU cores or above, it will be faster to run bundler in parallel:
DOCKER_BUILDKIT=1 docker build -t `source .env && echo $DOCKER_IMAGE` --ssh default --build-arg BUNDLER_JOBS=3 .

# Otherwise, or if you're not sure
DOCKER_BUILDKIT=1 docker build -t `source .env && echo $DOCKER_IMAGE` --ssh default .
```

### Directly on host system

#### Installing the correct runtime version

If you're going to use your host system, it's recommended you [install rvm](https://rvm.io/rvm/install) before proceeding. The version of rvm that you use is not particularly important - you're encouraged to regularly update to get the latest bugfixes and features.

Use `rvm` to install the correct Ruby language version:

```bash
rvm install `cat .ruby-version`
```

#### Installing the correct versions of dependencies

Install the same version of Bundler for that Ruby version, as has previously been used for managing the Gemfile:

```bash
which bundler || gem install bundler -v `sed -n -e '/BUNDLED WITH/,1{n;p;}' Gemfile.lock
```

Use `bundler` to install the application's gems:

```
bundle install
```

## Setup the development and test databases

You can either start from an empty database, or see your teammates for a suitable database dump as a starting point for your development (recommended).

### Using Docker

You'll likely want to start from a recent database dump. To import the sql file (skip this step if starting from a fresh database):

⚠️ This command may fail the first time you run it because it doesn't wait for the database to be up and ready before it attempts to import the database dump. If this happens, wait 30 seconds and try again.

```bash
docker-compose run --rm db-console < database-dump.sql
```

Start the `console` container, run any outstanding migrations:

```bash
docker-compose run --rm console

./bin/rails db:migrate:with_data
./bin/rails db:seed
```

To set up the test database, create a separate `test-console` container, to run all migrations and import the database seeds:

```bash
docker-compose run --rm test-console

./bin/rake db:migrate:with_data
./bin/rails db:seed
```

### Directly on host system
         
Create the test and development databases:

```bash
rails db:create 
rails db:create RAILS_ENV=test
```

You'll likely want to start from a recent database dump for your development database:

```bash
mysql ohc_api_development < database-dump.sql
```

Run all outstanding migrations:

```bash
rails db:migrate:with_data db:seed
rails db:migrate:with_data RAILS_ENV=test
```

## Starting the Rails server

Once you've built your Docker image locally (and tagged it as `dubit/ohc-api:latest`) you can start the application using Docker Compose:

### Using Docker

```bash
docker-compose up app
```

### Directly on host system

```bash
rails s
```

## Running the test suite

### Using Docker

You can run the tests after you've built the Docker image:

```bash
docker-compose run --rm tests
```

To run only the tests that failed on the most recent run:

```bash
docker-compose run --rm tests-only-failures
```
                                      
To start a service that watches the file system for changes and runs related spec files:

```bash
docker-compose run --rm tests-watch
```

### Directly on host system

In order to run the acceptance tests, you need to install a background application called `chromedriver`, which is basically the transfer protocol between Selenium and Chrome. On a mac, you do it with the command below:

```shell
brew cask install chromedriver
```

If you see some errors like the following:

```shell
Selenium::WebDriver::Error::SessionNotCreatedError:
session not created: Chrome version must be between 70 and 73
```

You probably need to upgrade the to a newer `chromedriver` version with the command below:

```shell
brew cask upgrade chromedriver
```

On Catalina, you also need to permit the Chromedriver executable:

```shell
cd `brew --prefix`/Caskroom/chromedriver
xattr -d com.apple.quarantine <relative-path-to-chromedriver>
```

The entire test suite can then be run directly with RSpec:

```bash
bundle exec rspec
```

If you do so and tests fail, the results are saved in a temporary file so the next time you run the tests, you have the option of only running those that failed on the previous execution:

```bash
bundle exec rspec --only-failures
```

You can run the test suite so that the matching specs are run every time you save changes to a source file:

```bash
bundle exec guard -P rspec -c
```

The configuration of watching the file system and running the corresponding files is done through the `Guardfile` in the root of the application.

## Fixing tests

### Suggested workflow

1. Run the test suite before making any changes to make sure they all pass.
1. If any tests are failing, start at the bottom and focus them one at a time by finding the file and line number of the failing test and focusing it using `, focus: true` after the test description and before the `do` block.
1. Run the test suite using the watch service (described below) and save the test file, so it is run.
1. Fix the broken spec with whatever necessary changes or debugging steps that may be required, while keeping an eye on the test results in the terminal window running guard.
1. Once fixed, move onto the next failing test (removing `, focus: true` when you are done).
1. Once you have a passing test suite, run the whole thing again and commit your changes.

### Using Docker

If you are fixing a particular test and want to run it after each modification, no matter what file you've changed:

```bash
docker-compose run --rm tests-watch-debug
```

Then focus the test you're working on with the `focus: true` tag. Every time you modify that file or another in the project, it will run the same test so you can rapidly get debugging information or verify whether you've fixed the test.

If you tag a feature or request spec with `driver: :dev`, it will run the tests in a Chrome window with the devtools open inside the Selenium server container. To view the Chrome window, you need to connect to `vnc://127.0.0.1:5900` using a VNC client like **VNC Viewer** (note that the native **Screen Sharing** Mac application doesn't seem to work.) When prompted, enter the password `secret`. See [here](https://github.com/SeleniumHQ/docker-selenium/tree/trunk#debugging) for more information.

You can then place a `binding.pry` statement at the end of your test, or just before a failed operation or assertion and step through each operation in the browser using the Capybara DSL.

```ruby
it 'then does something', driver: :dev do
  # Earlier test steps ...
  binding.pry
end
```

### Directly on host system

```bash
bundle exec guard -P rspec -c -G Guardfile.debug
```

Then focus the test you're working on with the `focus: true` tag. Every time you modify that file or another in the project, it will run the same test so you can rapidly get debugging information or verify whether you've fixed the test.

## Troubleshooting tests

### Testing parts of the application that use transactions

Because MySQL doesn't support nested transactions (it merges them into one) and RSpec uses transactions to rollback to a clean database state before running each test, you need to use a different rollback strategy for specs that rely on a transaction rolling back.

You can do this by adding a `rollback: :truncation` tag to the spec.

The transaction rollback strategy is used by default for specs other than those run through selenium because it is much faster than the truncation one. When using selenium as a separate docker service (e.g. running using `docker-compose tests`) the truncation rollback strategy is used by default.

# Overview

## JSON API

This project uses Netflix's implementation of the [JSON API specification](https://jsonapi.org/): [fast_jsonapi](https://github.com/Netflix/fast_jsonapi) to provide JSON serializers.

To define a new serializer, add a file in the `app/serializers` directory and have the class inherit from `API::V2::ApplicationSerializer`.

```ruby
module API
  module V2
    class UserSerializer < API::V2::ApplicationSerializer

    end
   end
end
```

The project uses [json_parameters](https://github.com/visualitypl/jsonapi_parameters) to parse JSON request parameters to the format that Rails expects. You need to use the `from_jsonapi` helper method:

```ruby
def create_params
  params.from_jsonapi.require(:model).permit(:name)
end
```

## Documentation

This repository uses [SDoc](https://github.com/zzak/sdoc) for its source code documentation.

You can generate the documentation using:

```bash
sdoc app/controllers/api/ --main base_controller.rb --title 'Faith Spark API'
```

## Error reporting

This project uses the [airbrake gem](https://github.com/airbrake/airbrake) to report errors to an Errbit server. Configure your project's details in `config/initializers/airbrake_as_errbit.rb`.

Uncaught exceptions are reported by default, but if you want to explicitly report an error, use the [Airbrake.notify method](https://github.com/airbrake/airbrake-ruby#airbrakenotify).

Use the `ERROR_ENVIRONMENT` environment variable to set what environment is reported to Errbit (otherwise the current Rails environment is used).
