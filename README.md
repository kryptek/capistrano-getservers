# Capistrano::Getservers

capistrano-getservers makes it easier for you to deploy to your EC2 or
Rackspace Cloud instances. By supplying a Hash or Array, respectively, to the `get_servers` method,
capistrano-getservers connects to the appropriate service and retrieves all instances with
matching criteria.


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

Environment variables (AWS EC2)
* `export AWS_SECRET_ACCESS_KEY=''`
* `export AWS_ACCESS_KEY_ID=''`

Environment variables (Rackspace)
* `export RACKSPACE_API_KEY=''`
* `export RACKSPACE_USERNAME=''`

## Usage

### Retrieving instances within Capistrano

#### AWS EC2
In your capistrano script:
```ruby
get_servers(:db, 'us-east-1', {'app' => 'app_name', 'cluster' => 'cluster', 'environment' => 'environment' ... })
```

#### Rackspace Cloud Servers
In your capistrano script:
```ruby
get_servers(:app, :ord, ['server1','server2','server3'])
```

### Retrieving instances from your CLI

First, add support for CLI arguments. I haven't personally tested using
both AWS and Rackspace at the same time, but if you need to, it should work just fine, really.

#### AWS EC2
In your capistrano script:
```ruby
set :tags, ENV['TAGS'] || {}
cli_tags = parse(tags)
get_servers(:role, region, cli_tags)
```

#### Rackspace
```ruby
set :names, ENV['NAMES'].split(',') || []
get_servers(:role, region, names)
```

Then, pass your tags/instance names via the command line:

##### AWS
`$ cap staging deploy TAGS=key1:value1,key2:value2,key3:value3...`

##### Rackspace
`$ cap staging deploy NAMES=web001,awesomeserver,blah...`

### Instances behind Amazon's VPC or that require a proxy
If you have instances located in a VPC with no public IP address,
capistrano-getservers will return their private ip address. You will
then need to use capistrano's gateway support to deploy to these
machines.

The following line of code accomplishes just that:

```
set :gateway, "gateway_address"
```

### Notes

You can pass `nil` as the second parameter to have capistrano-getservers
default to the `us-east-1` region for Amazon EC2 or `dfw` for Rackspace
Cloud servers.

All servers will receive the role 'web' unless you specify a different
role using the `get_servers` method.

Example: `get_servers(:role, 'us-east-1', {'deploy' => 'some value', 'app' => 'some_value'})`

Example: `get_servers(:role, :ord, ['web001','dbserver'])`

## Changelog

Version 2.0.0:
* Added support for Rackspace Cloud Servers

Version 1.0.3:
* get_servers now returns private instance ip addresses if no public
  address is available. See VPC notes above for more info.

Version 1.0.2:
* Added region support for Getservers.  Had to change the function
  get_servers for this, so it's now: get_servers(:role,'region',tags)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
