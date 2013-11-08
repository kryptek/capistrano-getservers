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
      # Purpose: Retrieves a list of instances matching when the
      #          block yields true
      #
      #          Matching instances are applied to the Cap server
      #          list.
      #
      # Usage: get_servers(:app) {|inst| inst.name =~ /^www\./}
      #
      # Returns: Nothing
      #############################################################
      def get_servers(role=nil)
        fog_servers.each do |instance|
          begin
            if yield(instance)
              puts "# #{role}: #{instance.name} [#{(instance.public_ip_address || instance.private_ip_address)}]"
              server (instance.public_ip_address || instance.private_ip_address), (role || :web)
            end
          rescue => error
            puts "[ERROR] #{error.message}"
          end
        end

      end

      def fog_servers
        @fog_servers ||= (fog_service.servers.all || [])
      end

      def fog_service
        @fog_service ||= ::Fog::Compute.new(fog_settings)
      end

    end
    include GetServers
  end
end
