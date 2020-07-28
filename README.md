# URL SHORTENER SERVER

This is the API for a simple URL shortener application written in Ruby on Rails using Postgres as database

# URL slug generator algorithm

The algorithm used takes advantage of a custom built-in encoder (lib/base_encoder.rb).

Basically this encoder generate a given number on base 10 on positional numeric system represented by an list of possible values. The base will be the lenght of the given charset list and the symbols will be matched by its position on the list.

Example.:

To create a hexadecimal number you would do:
```ruby
charset = %w(0 1 2 3 4 5 6 7 8 9 A B C D E F)
BaseEncoder.encode(10, charset)
# => 'A'
```

So, I take advantage of this algorithm to generate the slugs based on the ID of the record on the database, using a charset made of numbers from 0 to 9 and letters from a to z and A to Z.

This way I don't need to store the slug and also I can rely on the database's auto increment to avoid conflicts

Also, I need to decode the slug after to know which ID that slug represents (BaseEncoder.decode)


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



