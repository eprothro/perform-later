# cassie-rails

This project is in alpha. We're iterating to provide important features in a lightweight and loosely coupled way.

`cassie-rails` provides Rails integration for `cassie` application support. See the cassie readme for information on general usage

### Installation

```ruby
# Gemfile
gem 'cassie-rails', '~> 1.0.0.alpha'
```
or
```bash
$ gem install cassie-rails --pre
```

### Database Configuration

Similar to how `config/database.yml` stores relational databse configuration, `config/cassandra.yml` stores cassandra database configuration.

```
rails g cassandra:config
```

This will create `config/cassandra.yml` with default settings. All cluster and session [configuration options from `cassandra-driver`]() are supported (`hosts`, `port`, and `keyspace` shown below).

```yml
development:
  hosts:
    - 127.0.0.1
  port: 9042
  keyspace: my_app_development
```

Configure the options for each application environment.

See the cassie readme for more information on [Database Configuration](https://github.com/eprothro/cassie#database-configuration)