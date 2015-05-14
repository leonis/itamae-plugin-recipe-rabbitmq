# Install RabbitMQ plugins

require 'pathname'
require Pathname.new(__FILE__).join('../../rabbitmq.rb').to_s

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
