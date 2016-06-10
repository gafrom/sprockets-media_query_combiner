require 'tilt' unless Sprockets.respond_to? :register_postprocessor
require 'sass/media_query_combiner/combiner'

module Sprockets
  module MediaQueryCombiner

    class Processor
      def self.choose_processor
        return self if Sprockets.respond_to? :register_postprocessor
        TiltProcessor
      end
      def self.call(input)
        STDOUT.puts "*"*100 + "Sprockets Processor"
        Sass::MediaQueryCombiner::Combiner.combine input[:data]
      end
    end

    class TiltProcessor < Tilt::Template
      def prepare
      end

      def evaluate(context, locals, &block)
        STDOUT.puts "*"*100 + "Tilt Processor"
        Sass::MediaQueryCombiner::Combiner.combine data
      end
    end

  end
end
