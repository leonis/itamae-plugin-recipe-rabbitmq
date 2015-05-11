# Install RabbitMQ plugins
#
# NOTE: I think rabbitmq_plugin should be defined as resource like gem_package.
#

# FIXME: this constant should be define dynamically.
CMD_PATH = '/usr/lib/rabbitmq/bin'

default_plugins = %w( rabbitmq_management rabbitmq_management_visualiser )

node_plugins =
  if !node[:rabbitmq].nil? && !node[:rabbitmq][:plugins].nil?
    node[:rabbitmq][:plugins]
  else
    []
  end

(default_plugins.concat(node_plugins).uniq.sort).each do |name|
  execute "enable rabbitmq '#{name}' plugin" do
    command "#{CMD_PATH}/rabbitmq-plugins enable #{name}"
    not_if "#{CMD_PATH}/rabbitmq-plugins list | grep '#{name} ' | grep -i '[E]'"
    notifies :restart, 'service[rabbitmq-server]'
  end
end
