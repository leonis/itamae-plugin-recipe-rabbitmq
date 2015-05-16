# Install RabbitMQ plugins

include_recipe 'rabbitmq::default'

service 'rabbitmq-server' do
  action :nothing
end

node.reverse_merge!(
  rabbitmq: {
    plugins: []
  }
)

(node[:rabbitmq][:plugins].uniq.sort).each do |name|
  rabbitmq_plugin name do
    action :enable
    notifies :restart, 'service[rabbitmq-server]'
  end
end
