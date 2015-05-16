# Enable RabbitMQ service
include_recipe 'rabbitmq::default'

service 'rabbitmq-server' do
  action [:enable, :start]
end
