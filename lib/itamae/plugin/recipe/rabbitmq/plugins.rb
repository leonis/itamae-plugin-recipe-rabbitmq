# Install RabbitMQ plugins
#
# NOTE: I think rabbitmq_plugin should be defined as resource like gem_package.
#

# FIXME: this constant should be define dynamically.
CMD_PATH = '/usr/lib/rabbitmq/bin'

node_plugins =
  if !node[:rabbitmq].nil? && !node[:rabbitmq][:plugins].nil?
    node[:rabbitmq][:plugins]
  else
    []
  end

(node_plugins.uniq.sort).each do |name|
  execute "enable rabbitmq '#{name}' plugin" do
    command "#{CMD_PATH}/rabbitmq-plugins enable #{name}"
    not_if "#{CMD_PATH}/rabbitmq-plugins list | grep '#{name} ' | grep -iv '[E]'"
    notifies :restart, 'service[rabbitmq-server]'
  end
end
