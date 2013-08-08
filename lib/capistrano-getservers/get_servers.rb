require 'fog'
require 'capistrano'

unless Capistrano::Configuration.respond_to?(:instance)
  abort 'capistrano-getservers requires Capistrano >= 2'
end

module Capistrano
  class Configuration
    module GetServers
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
      def get_servers(role=nil, region=nil, cli_tags)

        ec2 = Fog::Compute::AWS.new(
          aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
          aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
          region: region
        )

        ec2.servers.all.each do |instance|
          begin
            instance_tags = instance.tags.reject { |k,v| cli_tags[k] != instance.tags[k] }
            server (instance.public_ip_address || instance.private_ip_address), (role || :web) if instance_tags.eql?(cli_tags)
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
    include GetServers
  end
end
