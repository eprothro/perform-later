# Perform Later
`perform-later` provides asyncronous worker/job support for objects with a convention that encourages good object oriented design.

It is a simple and lightweight adapter that helps decouple job/worker initialization logic from object behavior logic.

It helps encourage objects with async/job/worker behavior to be more maintainable, easier to change, and faster to test thoroughly.

### Requirements
  * `ruby` 2.2 or later
  * currently `Sidekiq` is the only client supported

### Installation

```ruby
# Gemfile
gem "perform-later", "~> 1.0.0.alpha"
```
or
```bash
$ gem install perform-later --pre
```

### Usage

Perform Later allows a class to add support for making an existing method call to be performed later (e.g. through the out-of-process, asyncronous bus) with a call to `perform_later`.

```ruby
class SomeObject
  include PerformLater

  perform_later :do_work

  def do_work
    SomeService.do_work
  end
end
```

```ruby
SomeObject.do_work_later
```

The class can declare that some deserialization should happen to put the object in the correct state when executing with data from the asyncronous bus.

```ruby
class SomeObject
  include PerformLater

  attr_reader :resource1, :resource2

  def initialize(resource1, resource2)
    @resource1 = resource1
    @resource2 = resource2
  end

  perform_later :do_work, after_deserialize: :some_deserialization_for_work

  def do_work
    SomeService.do_work(resource1, resource2)
  end

  private

  def some_deserialization_for_work(param1, param2)
    @resource1 = SomeResource.find(async_bus_param1)
    @resource2 = SomeOtherResource.find(async_bus_param2)
  end
end
```

```ruby
SomeObject.do_work_later(resource1.id, resource2.id)
```
or, use the `_async` alias if you prefer
```ruby
SomeObject.do_work_async(resource1.id, resource2.id)
```

The class can further decouple from asyncronous implmentation by allowing custom serialization to happen before parameters are serialized for the aysncronous bus (to be consumed by the asyncronous client).

```ruby
class SomeObject
  include PerformLater

  attr_reader :resource1, :resource2

  def initialize(resource1, resource2)
    @resource1 = resource1
    @resource2 = resource2
  end

  perform_later :do_work, before_serialize: :some_serialization_for_work
                          after_deserialize: :some_deserialization_for_work,


  def do_work
    SomeService.do_work(resource1, resource2)
  end

  private

  def self.some_serialization_for_work(resource1, resource2)
    [resource1.id, resource2.id]
  end

  def some_deserialization_for_work(param1, param2)
    @resource1 = SomeResource.find(async_bus_param1)
    @resource2 = SomeOtherResource.find(async_bus_param2)
  end
end
```

```ruby
SomeObject.do_work_later(resource1, resource2)
```

> **Note:**
>
> When an object is initialized within the asyncronous process, the class's `initialize` method will receive required parameters with `null` values.
> Paramters to `initialize` do not need to be made optional, but the object must be able to initialize successfully with `null` parameter values.

### Logging

Including `PerformLater` adds a `logger` attribute. It also logs the job id of the enqueued job at a `debug` level.

```
  SomeObject.do_work_later
  # => Rails.logger prints {"job_id": "a7be5c33", "class": "SomeObject", "method":"do_work", "msg": "queued for later execution"} with any tags, etc.
```

The `PerformLater::logger` is used, which defaults to `Sidekiq.logger`. It is recommended to set the Sidekiq logger to the application logger for the syncronous process.

Rails/Sidekiq Example:

```ruby
# production.rb

Rails.application.configure do

  # only use one logger, determine based on process running
  if $PROGRAM_NAME =~ /sidekiq/
    config.logger = Sidekiq.logger
  else
    config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
    config.log_tags = [ :uuid ]

    Sidekiq.logger = config.logger
  end

  Rails.logger = config.logger
```

This makes it easy to tie a job back to a request, among other things.

### Motivation

Asyncronous libraries (Sidekiq, DelayedJob, ActiveJob, Resque etc) typically couple the algorithm of the behavior being performed, with serialization and deserialization from the asyncronous bus.

```ruby
class SomeTypicalWorker
  include SomeAsyncronousLibrary::Worker

  def perform(async_bus_param1, async_bus_param2)
    # loading state from async bus
    resource1 = SomeResource.find(async_bus_param1)
    resource2 = SomeOtherResource.find(async_bus_param2)

    # algorithm of behavior being performed
    SomeService.do_work(resource1, resource2)
  end
end
```
In this trivial example, maybe this coupling is not so evil. However as behavior evolves, or for more complex behaviors, this can tend to lead to:

  * WET code, as logic is copied into a worker class when it is time to be executed asyncronously
  * Diffult to maintain classes, as they are usually too coupled to asyncronous context, and don"t tend to follow good object oriented design
  * poor tests, as logic is coupled with initialization, more procedural, and less object oriented
  * slow tests, as each and every algorithm test may be coupled to the persistence layer

Overall, these concerns lead to classes that resist refactoring and future change.

These tendencies can be more easily avoided with a simple decoupling:

```ruby
class SomeObject
  include SomeAsyncronousLibrary::Worker

  attr_reader :resource1, :resource2

  def perform(*args)
    setup_from_async(*args)

    do_work
  end

  def do_work
    SomeService.do_work(resource1, resource2)
  end

  private

  def setup_from_async(async_bus_param1, async_bus_param2)
    @resource1 = SomeResource.find(async_bus_param1)
    @resource2 = SomeOtherResource.find(async_bus_param2)
  end
end
```

With this decoupling, future changes are easier to reason about in a object oriented manner. Also, its algorithm and its asyncronous loading logic are now easily tested in isolation.

This library exists simply to simplify and help encourage this decoupled design.

### Advanced Usage

#### Aliasing

You may customize the name of the asyncronous entry point with the `as` option. One use case might be enabling asyncronous execution of methods that don't `raise` when they are unsuccessful. Most asynronous jobs are considered successful unless they raise an exception.

The `:as` option accepts a string, symbol, or array of strings/symbols each of which will act as an alias for the asyncronous entry point.

```ruby
  perform_later :do_work!, as: :do_work_later

  def do_work
    do_work!
  rescue RecordInvalidError
    false
  end

  def do_work!
    #some work that might raise RecordInvalidError
  end
```

```
SomeObject.do_work_later
```

### Contributing

If you would like to see another client supported, please open an issue.