require 'fog'
require 'capistrano'

unless Capistrano::Configuration.respond_to?(:instance)
  abort 'capistrano-getservers requires Capistrano >= 2'
end

module Capistrano
  module GetServers

    def self.extend(configuration)
      configuration.load do
        Capistrano::Configuration.instance.load do

          _cset(:aws_secret_access_key, ENV['AWS_SECRET_ACCESS_KEY'])
          _cset(:aws_access_key_id, ENV['AWS_ACCESS_KEY_ID'])
          _cset(:rackspace_api_key, ENV['RACKSPACE_API_KEY'])
          _cset(:rackspace_username, ENV['RACKSPACE_USERNAME'])
          _cset(:default_role, :web)

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

            # Rackspace regions are a 3 letter code (i.e. 'ord')
            if region.size == 3
              rackspace = Fog::Compute.new(
                provider: 'Rackspace',
                rackspace_api_key: fetch(:rackspace_api_key),
                rackspace_username: fetch(:rackspace_username),
                rackspace_region: region
              )

              rackspace.servers.select do |rackspace_server|
                if cli_tags.include?(rackspace_server.name)
                  server (rackspace_server.ipv4_address || rackspace_server.addresses['private']['addr']), (role || :web)
                end
              end

            else
              ec2 = Fog::Compute::AWS.new(
                aws_secret_access_key: fetch(:aws_secret_access_key),
                aws_access_key_id: fetch(:aws_access_key_id),
                region: region
              )

              ec2.servers.all.each do |instance|
                begin
                  instance_tags = instance.tags.reject { |k,v| cli_tags[k] != instance.tags[k] }
                  server (instance.public_ip_address || instance.private_ip_address), (role || :web) if instance_tags.eql?(cli_tags)
                rescue
                end
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
            tags.split(',').inject({}) { |hash, pair| Hash[*pair.split(':')].merge(hash) }
          end

        end
      end
    end

  end
end

if Capistrano::Configuration.instance
  Capistrano::GetServers.extend(Capistrano::Configuration.instance)
end
