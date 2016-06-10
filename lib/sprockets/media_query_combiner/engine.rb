require 'sprockets/media_query_combiner/processor'

if defined?(::Rails)
  module Sprockets
    module MediaQueryCombiner
      
      class Engine < ::Rails::Engine
        initializer :setup_media_query_combiner, after: 'sprockets.environment', group: :all do |app|        
          # support for all Sprockets versions (up to 4.X)
          sprockets_env = app.assets || Sprockets
          sprockets_env.register_postprocessor    'text/css', Sprockets::MediaQueryCombiner::Processor.choose
          sprockets_env.register_bundle_processor 'text/css', Sprockets::MediaQueryCombiner::Processor.choose
        end
      end

    end
  end
end
