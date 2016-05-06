# Perform Later
`perform-later` provides asyncronous worker/job support for objects with a convention that encourages better object oriented design.

It is a simple and lightweight adapter that helps decouple job/worker initialization logic from object behavior logic.

It helps encourage objects with async/job/worker behavior that are more maintainable, easier to change, and faster to test thoroughly.

### Requirements
  * `ruby` 2.2 or later
  * currently `Sidekiq` is the only client supported

### Installation

```ruby
# Gemfile
gem 'perform-later', '~> 1.0.0.alpha'
```
or
```bash
$ gem install perform-later --pre
```

### Usage

Allow a method call to be performed later, with loose coupling to the asyncronous client.

#### Declaration
```ruby
class SomeObject
  include PerformLater

  attr_reader :resource1, :resource2

  def initialize(resource1, resource2)
    @resource1 = resource1
    @resource2 = resource2
  end

  perform_later :do_work, after_initialize: :load_from_async

  def do_work
    SomeService.do_work(resource1, resource2)
  end

  private

  def load_from_async(param1, param2)
    @resource1 = SomeResource.find(async_bus_param1)
    @resource2 = SomeOtherResource.find(async_bus_param2)
  end
end
```

#### Invocation

```ruby
SomeObject.do_work_later(resource1.id, resource2.id)
```
or, use the `_async` alias if you prefer
```ruby
SomeObject.do_work_async(resource1.id, resource2.id)
```

### Motivation

Asyncronous libraries (Sidekiq, DelayedJob, ActiveJob, Resque etc) typically couple the algorithm of the behavior being performed, with the loading of state of that object from the asyncronous bus.

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
  * Diffult to maintain classes, as they are usually too coupled to asyncronous context, and don't tend to follow good object oriented design
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

### Contributing

If you would like to see another client supported, please open an issue.