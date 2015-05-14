# Itamae::Plugin::Recipe::Rabbitmq

[Itamae](https://github.com/itamae-kitchen/itamae) plugin to install RabbitMQ.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'itamae-plugin-recipe-rabbitmq'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install itamae-plugin-recipe-rabbitmq

## Usage

### Recipe

#### package recipe

Install RabbitMQ by package.

```
# your recipe
include_recipe 'rabbitmq::package'
```

#### config recipe

Just only add vhost, user, permissions to rabbitmq.

```
# your recipe
include_recipe 'rabbitmq::config'
```

NOTE: Currently, this gem does not support to configure `/etc/rabbitmq/rabbitmq.conf` .

#### plugin recipe

Enable RabbitMQ plugins to be included in the RabbitMQ package.

```
# your recipe
include_recipe 'rabbitmq::plugin'
```

When include this recipe, you can use `rabbitmq_plugin` resource.

```
# your recipe
include_recipe 'rabbitmq::plugin'

# enable 'rabbitmq_management' plugin on RabbitMQ
rabbitmq_plugin 'rabbitmq_management' do
  action :enable
  notifies :restart, 'service[rabbitmq-server]'
end

# disable 'amqp_client' plugin on RabbitMQ
rabbitmq_plugin 'amqp_client' do
  action :disable
  notifies :restart, 'service[rabbitmq-server]'
end
```

#### enable recipe

Enable RabbitMQ service.

```
# your recipe
include_recipe 'rabbitmq::enable'
```

### Node

Use this with `itamae -y node.yml`

```
# node.yml
rabbitmq:
  version: 3.1.5
  vhost: /sensu
  user:
    name: sensu
    password: secret
    tag: administrator
  plugins:
    - rabbitmq_management
    - rabbitmq_management_visualiser
```

| name | required? | description |
|:-----|:---------:|:------------|
| rabbitmq.version | optional | rabbitmq version to be installed |
| rabbitmq.vhost   | optional | vhost to be created |
| rabbitmq.user    | optional | user to be added |
| rabbitmq.user.name | optional | username |
| rabbitmq.user.password |  optional | password |
| rabbitmq.user.tag | optional | user tag on rabbitmq (if empty, tag will cleared) |
| rabbitmq.plugins | optional | enabled rabbitmq plugins |

NOTE: You should not write password here directory.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/itamae-plugin-recipe-rabbitmq/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

Copyright 2015 Leonis & Co.

MIT License
