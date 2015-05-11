# Install & Configure RabbitMQ.
#
# This recipe created with reference to http://sensuapp.org/docs/0.18/install-rabbitmq

include_recipe 'erlang::package'

# Install
case node[:platform]
when 'redhat', 'fedora'
  execute 'import signing public-key for rabbitmq.' do
    command 'rpm --import http://www.rabbitmq.com/rabbitmq-signing-key-public.asc'
    not_if 'rpm -q rabbitmq-server'
  end

  rabbitmq_version =
    if !node[:rabbitmq].nil? && !node[:rabbitmq][:version].nil?
      node[:rabbitmq][:version]
    else
      nil
    end

  package 'rabbitmq-server' do
    version rabbitmq_version unless rabbitmq_version.nil?
  end
else
  fail 'Sorry your platform is not supported yet.'
end

# Configuration
service 'rabbitmq-server' do
  action [:enable, :start]
end
