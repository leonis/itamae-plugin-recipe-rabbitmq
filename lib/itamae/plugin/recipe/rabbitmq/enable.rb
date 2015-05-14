# Enable RabbitMQ service
service 'rabbitmq-server' do
  action [:enable, :start]
end
