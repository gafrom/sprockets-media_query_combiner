require 'sass/media_query_combiner/combiner'

module Sprockets
  module MediaQueryCombiner
    
    # serves to pick proper processor
    class Processor
      # returns processor class valid for current Sprockets version
      def self.choose
        return SprocketsProcessor if Sprockets.respond_to? :register_postprocessor
        TiltProcessor
      end
    end

    # for Sprockets >= 3.X
    class SprocketsProcessor
      def self.call(input)
        Sass::MediaQueryCombiner::Combiner.combine input[:data]
      end
    end

    # support for older Sprockets versions (<3.X)
    begin
      require 'tilt'

      class TiltProcessor < Tilt::Template
        def prepare
        end

        def evaluate(context, locals, &block)
          Sass::MediaQueryCombiner::Combiner.combine data
        end
      end
    
    rescue LoadError
      STDOUT.puts "Using native Sprockets processor"
    end

  end
end
