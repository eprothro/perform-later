# How to Contribute

## Bugs

A pull request with a failing test is the best way to report an issue.

If you are unable to reproduce with a failing test, try again :). If you're still unable, open an issue.

To run the unit suite:
  * Fork the repo and then clone with `git clone https://github.com/YOUR-USERNAME/perform-later`
  * Install the bundle with `bundle`
  * Run `rake spec`

## Ideas

Open an issue for conversation about any ideas or suggestions.


## Making Changes

### Unit tests

Unit tests should provide complete coverage of features and should not depend on an available redis/sidekiq server.


## Working with Changes

### Installing your changes locally

Run `rake install` to:
* Run the test suite
* Build the gem
* Install into your local gemset

Or you may want to reference your changes from another project:
* Add `gem "perform-later", path: 'YOUR-SOURCE-DIRECTORY/perform-later'` to your other project's `Gemfile`
* Run `bundle`
* Execution will now use the source files in `YOUR-SOURCE-DIRECTORY/perform-later`
* Changes are included automatically (by definition)

### Releasing (maintainers only)

Run `rake release` to:
* Run the full test suite
* Build the gem
* Publish the gem
* Bump the version (patch)

### Bumping the version

Bump version minor / major with `gem bump --version <minor|major>`.

Please don't include version bumps in your patches. Maintainers will handle this.
