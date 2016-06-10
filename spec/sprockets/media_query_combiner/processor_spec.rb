require 'sprockets' # so we know which processor to use in tests
require 'spec_helper'
require 'sprockets/media_query_combiner/processor'

module Sprockets::MediaQueryCombiner
  pretty_input_css = <<CSS
h3 {
  color: orange
}

@media (max-width: 480px) {
  h1 {
    color: red
  }
}

@media (max-width: 980px) {
  h4 {
    color: black
  }
}
@media (max-width: 480px) {
  h2 {
    color: blue
  }
}

b {
  color: yellow
}
CSS
  pretty_target_css = <<CSS
h3 {
  color: orange
}

b {
  color: yellow
}

@media (max-width: 480px) {
  h1 {
    color: red
  }

  h2 {
    color: blue
  }
}

@media (max-width: 980px) {
  h4 {
    color: black
  }
}
CSS
  ugly_input_css = "h3{color:orange}@media (max-width:480px){h1{color:red}}@media (max-width:980px){h4{color:black}}@media (max-width:480px){h2{color:blue}}\n"
  ugly_target_css = "h3{color:orange}@media (max-width:480px){h1{color:red}h2{color:blue}}@media (max-width:980px){h4{color:black}}\n"

  handler = 
    if Sprockets.respond_to? :register_postprocessor
      output = lambda { |input| SprocketsProcessor.call( { data: input } ) }
      SprocketsProcessor
    else
      output = lambda { |input| TiltProcessor.new { input }.evaluate(nil, nil) }
      TiltProcessor
    end

  describe handler do
    it "should work with pretty css" do
      output[pretty_input_css].should == pretty_target_css
    end

    it "should work with ugly css" do
      output[ugly_input_css].should == ugly_target_css
    end
  end

end
