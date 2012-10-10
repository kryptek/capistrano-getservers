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

## Usage

### Server Roles

All instances are assigned the 'web' role by default, unless you assign
an 'app' variable to the particular role you want to add servers to.

You can change the roles of the servers before they're added by doing
something like:

`set :app, 'database'`

### Retrieving instances within Capistrano

In your capistrano script:
```ruby
get_servers({'app' => 'app_name', 'cluster' => 'cluster', 'environment' => 'environment' ... })
```

### Retrieving instances from your CLI

In your capistrano script:
```ruby
set :tags, ENV['TAGS'] || {}
cli_tags = parse(tags)
get_servers(cli_tags)
```

Then, via the command line:

`$ cap staging deploy TAGS=key1:value1,key2:value2,key3:value3...`


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
