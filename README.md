# cassie-rails

This project is in alpha. We're iterating to provide important features in a lightweight and loosely coupled way.

`cassie-rails` provides Rails integration for the components most applications need to work with a Cassandra persistence layer:

* Database configuration and efficient session management
* Versioned schema migrations
* Query classes
* Test harnessing

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

Cassie provies database connection configuration (e.g. cluster and session) per environment.

Similar to how `config/database.yml` stores your relational databse configuration, `config/cassandra.yml` stores your cassandra database configuration.

```
rails g cassandra_configuration
```

This will create `config/cassandra.yml` with default settings.

```yml
development:
  hosts:
    - 127.0.0.1
  port: 9042
  keyspace: my_app_development
```

Configure the options for each of your application's environments.

See the cassie readme for more information on [Database Configuration](https://github.com/eprothro/cassie#database-configuration)

### Session Management

Essence of rails specific features/usage.

See the cassie readme for more information on [Session Management](https://github.com/eprothro/cassie#database-configuration)

### Versioned Migrations

Essence of rails specific features/usage.

See the cassie readme for more information on [Versioned Migrations](https://github.com/eprothro/cassie#versioned-migrations)

### Query Classes

Essence of rails specific features/usage.

See the cassie readme for more information on [Query Classes](https://github.com/eprothro/cassie#query-classes)

### Test Harnessing

Essence of rails specific features/usage.

See the cassie readme for more information on [Test Harnessing](https://github.com/eprothro/cassie#test-harnessing)