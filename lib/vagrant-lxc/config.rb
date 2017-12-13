module Vagrant
  module LXC
    class Config < Vagrant.plugin("2", :config)
      # An array of container's configuration overrides to be provided to `lxc-start`.
      #
      # @return [Array]
      attr_reader :customizations

      # A string that contains the backing store type used with lxc-create -B
      attr_accessor :backingstore

      # Optional arguments for the backing store, such as --fssize, --fstype, ...
      #
      # @return [Array]
      attr_accessor :backingstore_options

      # A string to explicitly set the container name. To use the vagrant
      # machine name, set this to :machine
      attr_accessor :container_name

      attr_accessor :fetch_ip_tries

      def initialize
        @customizations = []
        @backingstore = UNSET_VALUE
        @backingstore_options = []
        @container_name = UNSET_VALUE
        @fetch_ip_tries = UNSET_VALUE
      end

      # Customize the container by calling `lxc-start` with the given
      # configuration overrides.
      #
      # For example, if you want to set the memory limit, you can use it
      # like: config.customize 'cgroup.memory.limit_in_bytes', '400M'
      #
      # When `lxc-start`ing the container, vagrant-lxc will pass in
      # "-s lxc.cgroup.memory.limit_in_bytes=400M" to it.
      #
      # @param [String] key Configuration key to override
      # @param [String] value Configuration value to override
      def customize(key, value)
        @customizations << [key, value]
      end

      # Stores options for backingstores like lvm, btrfs, etc
      def backingstore_option(key, value)
        @backingstore_options << [key, value]
      end

      def finalize!
        @container_name = nil if @container_name == UNSET_VALUE
        @backingstore = "best" if @backingstore == UNSET_VALUE
        @existing_container_name = nil if @existing_container_name == UNSET_VALUE
        @fetch_ip_tries = 10 if @fetch_ip_tries == UNSET_VALUE
      end
    end
  end
end
