# Configure RabbitMQ
include_recipe 'rabbitmq::default'

unless node[:rabbitmq].nil?
  # create vhost
  unless node[:rabbitmq][:vhost].nil?
    execute 'create vhost on rabbitmq' do
      command "rabbitmqctl add_vhost #{node[:rabbitmq][:vhost]}"
      not_if "rabbitmqctl list_vhosts | grep '#{node[:rabbitmq][:vhost]}'"
    end
  end

  unless node[:rabbitmq][:user].nil?
    user = node[:rabbitmq][:user]

    execute 'create user on rabbitmq' do
      command "rabbitmqctl add_user #{user[:name]} #{user[:password]}"
      not_if "rabbitmqctl list_users | grep '#{user[:name]}'"
    end

    user_tag = (user[:tag].nil? ? '' : user[:tag])
    execute "add tag '#{user_tag}' to '#{user[:name]}' on rabbitmq" do
      command "rabbitmqctl set_user_tags #{user[:name]} #{user_tag}"
      not_if "rabbitmqctl list_users | grep #{user[:name]} | cut -f 2 | grep #{user_tag}"
    end

    if user[:rights]
      rights = user[:rights]

      permission_command = %(rabbitmqctl set_permissions -p #{rights[:vhost]} #{user[:name]} "#{rights[:conf]}" "#{rights[:write]}" "#{rights[:read]}")
      permission_pattern = "^#{rights[:vhost]}\\s#{rights[:conf]}\\s#{rights[:write]}\\s#{rights[:read]}$"

      execute "set permission to '#{user[:name]}' on rabbitmq" do
        command permission_command
        not_if "rabbitmqctl list_user_permissions #{user[:name]} | grep '#{permission_pattern}'"
      end
    end
  end
end
