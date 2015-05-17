require 'itamae'

module Itamae
  module Resource
    class RabbitmqUser < Base
      define_attribute :action, default: :add
      define_attribute :user_name, type: String, default_name: true
      define_attribute :password, type: String
      define_attribute :vhost, type: String
      define_attribute :permissions, type: String, default: nil
      define_attribute :tag, type: String

      def set_current_attributes
        super

        current.user_existance = user_exist?(attributes.user_name)

        case attributes.action
        when :add, :delete
          break
        when :set_permissions
          current.permission_existance =
            if current.user_existance
              permission_exist?(attributes.user_name, attributes.permissions)
            else
              false
            end
        else
          fail "'#{attributes.action}' is not supported on #{attributes.plugin_name}"
        end
      end

      def show_differences
        case attributes.action
        when :add
          return if current.user_existance

          Logger.formatter.color :green do
            Logger.info "Adding RabbitMQ user '#{attributes.user_name}'."
          end

        when :delete
          return unless current.user_existance

          Logger.formatter.color :green do
            Logger.info "Deleting RabbitMQ user '#{attributes.user_name}'."
          end
        when :set_permissions
          return unless current.user_existance

          Logger.formatter.color :green do
            Logger.info "Setting RabbitMQ user permissions for '#{attributes.user_name}' on vhost '#{attributes.vhost}'"
          end
        when :clear_permissions
          return if current.user_existance


        else

        end
      end

      def action_add(_options)
        return if current.user_existance

        rabbitmq_command!('add_user', attributes.user_name, attributes.password)
        updated!
      end

      def action_delete(_options)
        return unless current.user_existance

        rabbitmq_command!('delete_user', attributes.user_name)
        updated!
      end

      def action_set_permissions
        return unless current.user_existance

        options = []
        if attributes.vhost
          options << '-p'
          options << attributes.vhost
        end
        options.concat!(attributes.permissions.split(' ').map { |v| "'#{v}'" })
        rabbitmq_command!('set_permissions', *options)

        updated!
      end

      def action_clear_permissions
      end

=begin
      def action_set_tags
      end

      def action_clear_tags
      end

      def action_change_password
      end
=end

      private

      def check_params!
        case attributes.action
        when :add
          if attributes.password.nil?
            fail "Require password for RabbitMQ user '#{attributes.user_name}'"
          end
        end
      end

      def rabbitmq_command!(action, *args)
        run_command(['rabbitmqctl', action].concat(args))
      end

      def user_exist?(user)
        check_command("rabbitmqctl list_users | grep '^#{shell_escape(user)}'")
      end
    end
  end
end
