# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'itamae/plugin/recipe/rabbitmq/version'

Gem::Specification.new do |spec|
  spec.name          = 'itamae-plugin-recipe-rabbitmq'
  spec.version       = Itamae::Plugin::Recipe::Rabbitmq::VERSION
  spec.authors       = ['Daisuke Hirakiuchi']
  spec.email         = ['devops@leonisand.co']
  spec.license       = ['MIT']

  spec.summary       = 'Itamae plugin to install RabbitMQ.'
  spec.description   = 'Itamae plugin to install RabbitMQ by package.'
  spec.homepage      = 'https://github.com/leonis/itamae-plugin-recipe-rabbitmq'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_runtime_dependency 'itamae', '~> 1.2'
  spec.add_runtime_dependency 'itamae-plugin-recipe-erlang'
end
