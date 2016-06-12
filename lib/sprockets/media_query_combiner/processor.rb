require 'sprockets'
require 'sass/media_query_combiner/combiner'

module Sprockets
  module MediaQueryCombiner

    if Sprockets::VERSION[0,1].to_i >= 3
      class Processor
        def self.call(input)
          Sass::MediaQueryCombiner::Combiner.combine input[:data]
        end
      end
    else # support for ancient Sprockets
      require 'tilt'
      class Processor < Tilt::Template
        def prepare
        end

        def evaluate(context, locals, &block)
          Sass::MediaQueryCombiner::Combiner.combine data
        end
      end
    end

  end
end
