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

  versions_to_test = [2, 3]
  gem_spec = Gem::Specification.find_by_name 'sprockets'
  v = gem_spec.version.to_s[0,1].to_i
  
  versions_to_test.each do |version|

    # install Sprockets if necessary
    if version != v
      require 'rubygems/commands/install_command'
      cmd = Gem::Commands::InstallCommand.new
      cmd.handle_options ["--no-ri", "--no-rdoc", 'sprockets', '--version', "#{v}.6.0"]

      begin
        cmd.execute
      rescue Gem::SystemExitException => e
        puts "DONE: #{e.exit_code}"
      end

      puts "* using sprockets #{v}.6.0"
      gem 'sprockets', "#{v}.6.0"
      require 'sprockets'
    end

    output = 
      if Sprockets::VERSION[0,1].to_i >= 3
        lambda { |input| Processor.call( { data: input } ) }
      else
        lambda { |input| Processor.new { input }.evaluate(nil, nil) }
      end

    describe "Processor running with Sprockets #{version}" do
      it "should work with pretty css" do
        output[pretty_input_css].should == pretty_target_css
      end

      it "should work with ugly css" do
        output[ugly_input_css].should == ugly_target_css
      end
    end
    
  end


end
