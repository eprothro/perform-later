# Perform Later
`perform-later` provides asyncronous worker/job support with a convention that encourages idiomatic class design.

It is a simple and lightweight abstraction that helps decouple asyncronous bus logic from object behavior logic.

It encourages more maintainable async/job/worker code that is easier to change and easier to test thoroughly and quickly.

In a nutshell, `perform-later` allows you to

#### replace this

```ruby
# app/workers/do_work_worker.rb
class DoWorkWorker
  include Sidekiq::Worker

  def perform(async_data)
    init_resource_from_async_bus(async_data)
    # do work with resource
  end

  private

  def init_resource_from_async_bus(some_param)
    @resource = Resource.find_by_some_param(some_param)
  end
end
```
called by
```ruby
DoWorkWorker.perform_later(resource.id)
```
#### with this

```ruby
# lib/my-app/some_class.rb
class SomeClass
  perform_later :do_work

  def initialize(resource)
    @resource = resource
  end

  def do_work
    # do work with resource
  end

  module Async
    def serialize(resource)
      resource.id
    end

    def deserialize(id)
      resource = Resource.find_by_id(id)
      SomeClass.new(resource)
    end
  end
end
```
called by
```ruby
SomeClass.do_work_later(resource)
```

### Requirements
  * `ruby` 2.2 or later
  * currently `Sidekiq` is the only client supported

`jruby` 9 or later (experimental)

### Installation

```ruby
# Gemfile
gem "perform-later", "~> 1.1.0.alpha"
```
or
```bash
$ gem install perform-later --pre
```

### Usage Details

`PerformLater` adds support for making an existing method call asyncronously (e.g. through the out-of-process, asyncronous bus) with a call to `perform_later`.

```ruby
class SomeClass
  perform_later :do_work

  def do_work
    SomeService.do_work
  end
end
```

```ruby
SomeClass.do_work_later
```

The class can declare that some deserialization should happen to put the object in the correct state when executing with data from the asyncronous bus.

```ruby
class SomeClass
  attr_reader :resource1, :resource2

  def initialize(resource1, resource2)
    @resource1 = resource1
    @resource2 = resource2
  end

  perform_later :do_work

  def do_work
    SomeService.do_work(resource1, resource2)
  end

  module Async
    def deserialize(id1, id2)
      resource1 = SomeResource.find(id1)
      resource2 = SomeOtherResource.find(id2)
      SomeClass.new(resource1, resource2)
    end
  end
end
```

```ruby
SomeClass.do_work_later(resource1.id, resource2.id)
```
or, use the `_async` alias if you prefer
```ruby
SomeClass.do_work_async(resource1.id, resource2.id)
```
or, use the `Async` class method
```ruby
SomeClass::Async.do_work(resource1.id, resource2.id)
```

The class can further decouple from asyncronous implmentation by explicitly defining the serialization behavior within the Async module, instead having it implicitly defined separately by each caller.

```ruby
class SomeClass
  include PerformLater

  attr_reader :resource1, :resource2

  def initialize(resource1, resource2)
    @resource1 = resource1
    @resource2 = resource2
  end

  perform_later :do_work

  def do_work
    SomeService.do_work(resource1, resource2)
  end

  module Async
    def serialize(resource1, resource2)
      [resource1.id, resource2.id]
    end

    def deserialize(id1, id2)
      resource1 = SomeResource.find(id1)
      resource2 = SomeOtherResource.find(id2)
      SomeClass.new(resource1, resource2)
    end
  end
end
```

```ruby
SomeClass.do_work_later(resource1, resource2)
```

### Logging

Including `PerformLater` adds a `logger` attribute. It also logs the job id of the enqueued job at a `debug` level.

```
  SomeClass.do_work_later
  # => Rails.logger prints {"job_id": "a7be5c33", "class": "SomeClass", "method":"do_work", "msg": "queued for later execution"} with any tags, etc.
```

The `PerformLater::logger` is used, which defaults to `Sidekiq.logger`. It is recommended to set the Sidekiq logger to the application logger for the syncronous process, and vice-versa for the asyncronous process.

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
SomeClass.do_work_later
```

### Design

Calling `perform_later :do_work` defines

  * an `Async` module on the caller (`UserClass`)
    * default implemenation for `Async.serialize` returning `nil`
    * default implemenation for `Async.deserialize` returning `UserClass.new()`
  * a `Proxy` class on the `Async` module
  * a `do_work` class method on the `Proxy` class
    * calls the asyncronous client
  * a `do_work_later` class method on the caller (`UserClass`)
    * delegates to `Proxy.do_work`

The asyncronous client's entry point is this `UserClass::Async::Proxy` class.

When enqueuing, the proxy class calls `UserClass::Async.serialize` to determine what parameters to place in the async bus, along with the method being proxied.

Upon dequeuing, this proxy object calls `UserClass::Async.deserialize` to determine what object will receive the proxied message.

![Sequence Diagram](documentation/images/draw_io_sequence_diagram.png)

### Contributing

If you would like to see another client supported, please open an issue.