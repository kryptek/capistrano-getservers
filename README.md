# Capistrano::Getservers

capistrano-getservers makes it easier for you to deploy to your EC2
instances.  By supplying a Block to the `get_servers` method,
capistrano-getservers connects to any Fog compatable provider and retrieves all instances  when the supplied block returns true.


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
* `export RACKSPACE_USERNAME=''`
* `export RACKSPACE_API_KEY=''`
* `...`

## Usage

### Retrieving instances within Capistrano

In your capistrano script:
```ruby
set :fog_settings, {
  provider: 'Rackspace',
  rackspace_username: ENV['RACKSPACE_USERNAME'],
  rackspace_api_key: ENV['RACKSPACE_API_KEY'],
  rackspace_region: :lon, #optional
  version: :v2
}
get_servers(:web) {|instance| instance.name =~ /^(www|web)(-?\d*)\./ && instance.ready? }
get_servers(:app) {|instance| instance.name =~ /^(www|web)(-?\d*)\./ && instance.ready? }
```

### Instances behind Amazon's VPC / Private networks
If you have instances located in a VPC with no public IP address,
capistrano-getservers will return their private ip address. You will
then need to use capistrano's gateway support to deploy to these
machines.

The following line of code accomplishes just that:

```
set :gateway, "gateway_address"
```

### Notes

All servers will receive the role 'web' unless you specify a different
role using the `get_servers` method.

Example: `get_servers(:db) {|instance| instance.name =~ /^(db)(-?\d*)\./ && instance.ready? }`

## Changelog
Version 2.0.1:
* change get_servers method to accept a block instead of tags - this functionality is not backwards compatable but does enable a more flexable solution for not just AWS

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
