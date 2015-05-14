require 'itamae'

module Itamae
  module Resource
    class RabbitmqPlugin < Base
      define_attribute :action, default: :enable
      define_attribute :plugin_name, type: String, default_name: true

      PLUGIN_COMMAND = '/usr/lib/rabbitmq/bin/rabbitmq-plugins'

      def set_current_attributes
        super

        check_command!
        current.enabled = enabled_plugins.include?(attributes.plugin_name)
      end

      def show_differences
        case attributes.action
        when :enable
          return if current.enabled
        when :disable
          return unless current.enabled
        end

        Logger.formatter.color :green do
          Logger.info "#{attributes.plugin_name} will be #{attributes.action}"
        end
      end

      def action_enable(_options)
        enable_plugin! unless current.enabled
      end

      def action_disable(_options)
        disable_plugin! if current.enabled
      end

      private

      def list_plugins(args = [])
        plugin_command('list', ['-m'].concat(args)).stdout.split
      end

      def enabled_plugins
        list_plugins(['-E'])
      end

      def enable_plugin!
        result = plugin_command('enable', [attributes.plugin_name])
        updated! if result.stdout.match(/^The following plugins have been enabled:$/)
      end

      def disable_plugin!
        result = plugin_command('disable', [attributes.plugin_name])
        updated! if result.stdout.match(/^The following plugins have been disabled:$/)
      end

      def plugin_command(action, args = [])
        run_command([PLUGIN_COMMAND, action].concat(args))
      end

      def check_command!
        exit_status = run_command("[ -x #{PLUGIN_COMMAND} ]").exit_status
        return if exit_status == 0

        fail "rabbitmq-plugins command not found at '#{PLUGIN_COMMAND}'"
      end
    end
  end
end
