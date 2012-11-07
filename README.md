# Capistrano::Getservers

capistrano-getservers makes it easier for you to deploy to your EC2
instances.  By supplying a Hash to the `get_servers` method,
capistrano-getservers connects to EC2 and retrieves all instances with
matching tags.


## Installation

Add this line to your application's Gemfile:

    gem 'capistrano-getservers'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-getservers

## Requirements
Ruby Gems
* `gem 'capistrano'`
* `gem 'fog'`

Environment variables
* `export AWS_SECRET_ACCESS_KEY=''`
* `export AWS_ACCESS_KEY_ID=''`

## Usage

### Retrieving instances within Capistrano

In your capistrano script:
```ruby
get_servers(:db, 'us-east-1', {'app' => 'app_name', 'cluster' => 'cluster', 'environment' => 'environment' ... })
```

### Retrieving instances from your CLI

In your capistrano script:
```ruby
set :tags, ENV['TAGS'] || {}
cli_tags = parse(tags)
get_servers(:role, region, cli_tags)
```

Then, via the command line:

`$ cap staging deploy TAGS=key1:value1,key2:value2,key3:value3...`


### Notes

You can pass `nil` as the second parameter to have capistrano-getservers
default to the `us-east-1` region.

All servers will receive the role 'web' unless you specify a different
role using the `get_servers` method.

Example: `get_servers(:role,{'deploy' => 'some value', 'app' => 'some_value'})`

## Changelog

Version 1.0.2:
* Added region support for Getservers.  Had to change the function
  get_servers for this, so it's now: get_servers(:role,'region',tags)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
