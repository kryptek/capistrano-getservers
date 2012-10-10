require 'fog'

unless Capistrano::Configuration.respond_to?(:instance)
  abort 'capistrano-getservers requires Capistrano >= 2'
end

module Capistrano
  module Getservers
    #############################################################
    # def get_servers
    #
    # Purpose: Retrieves a list of EC2 instances containing a tag
    #          list which matches a supplied hash.
    #
    #          Matching instances are applied to the Cap server
    #          list.
    #
    # Usage: get_servers {'app' => 'zumba', 'stack' => 'web'}
    #
    # Returns: Nothing
    #############################################################
    def get_servers cli_tags

      ec2 = Fog::Compute::AWS.new(
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        aws_access_key_id: ENV['AWS_ACCESS_KEY_ID']
      )

      ec2.servers.all.each do |instance|
        begin
          instance_tags = instance.tags.reject { |k,v| cli_tags[k] != instance.tags[k] }
          server instance.public_ip_address, app.to_sym || :web if instance_tags.eql? cli_tags
        rescue => error
        end
      end

    end

    #############################################################
    # def parse
    #
    # Purpose: Parses a string object and returns a hash.
    #
    # Usage: parse 'k1:v1,k2:v2,k3:v3'
    #
    # Returns: {'k1' => 'v1', 'k2' => 'v2', 'k3' => 'v3'}
    #############################################################
    def parse tags
      return unless tags.class.eql? String
      tags.split(',').each.inject({}) { |hash, pair| hash.merge! Hash[*pair.split(':').flatten] }
    end

  end
end
