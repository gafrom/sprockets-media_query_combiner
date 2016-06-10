require 'sass/media_query_combiner/combiner'

module Sprockets
  module MediaQueryCombiner
    
    class Processor
      def self.choose
        return SprocketsProcessor if Sprockets.respond_to? :register_postprocessor
        TiltProcessor
      end
    end

    class SprocketsProcessor
      def self.call(input)
        STDOUT.puts "*"*100 + "Sprockets Processor"
        Sass::MediaQueryCombiner::Combiner.combine input[:data]
      end
    end

    begin    
      require 'tilt'

      class TiltProcessor < Tilt::Template
        def prepare
        end

        def evaluate(context, locals, &block)
          STDOUT.puts "*"*100 + "Tilt Processor"
          Sass::MediaQueryCombiner::Combiner.combine data
        end
      end
    
    rescue LoadError
      STDOUT.puts "Using native Sprockets processor"
    end

  end
end
