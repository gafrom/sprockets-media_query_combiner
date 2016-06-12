require 'sass/media_query_combiner/combiner'

module Sprockets
  module MediaQueryCombiner

    spec = Gem::Specification.find_by_name 'sprockets'
    if spec.version.to_s[0,1].to_i >= 3
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
