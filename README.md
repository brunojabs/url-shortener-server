# URL SHORTENER SERVER

This is the API for a simple URL shortener application written in Ruby on Rails using Postgres as database

# Setup and run

To run the application you can setup a ruby + postgres environment yourself or just use docker with docker-compose (recommended).
The docs instructions bellow are valid for docker-compose environment only.

## With Docker + Docker compose

Once you have installed docker and docker-compose (you can follow [these instructions](https://docs.docker.com/get-docker/)) just run

```shell
./scripts/build
```

*Note:* You may need to run `chmod +x ./scripts/*` so you can execute the commands

This will take care of build the docker image and setup the project for you.

### Running the application

Just run

```shell
./scripts/start
```

### Stopping

Just run

```shell
./scripts/stop
```

### Executing commands

In case you need to execute commands such as `bundle install` or `rails g` just run

```shell
./scripts/exec your-command-here
```

### Running tests

To run all tests just run

```shell
./scripts/test
```

If you want to run an specific test, just run

```shell
./scripts/test path/to/test.rb
```

### Accessing container's shell

Run

```shell
./scripts/shell
```

Can be used to run tests inside the container without having to wait the container to start
