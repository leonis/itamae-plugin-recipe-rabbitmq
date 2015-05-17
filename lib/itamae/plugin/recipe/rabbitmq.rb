require 'pathname'
require Pathname.new(__FILE__).join('../../resource/rabbitmq_plugin.rb').to_s
require Pathname.new(__FILE__).join('../../resource/rabbitmq_user.rb').to_s

module Itamae
  module Plugin
    module Recipe
      module Rabbitmq
      end
    end
  end
end
