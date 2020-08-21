require_relative '../init.rb'

ruby_engine_test_init = "./#{RUBY_ENGINE}.rb"
if File.exist?(File.join(__dir__, ruby_engine_test_init))
  require_relative ruby_engine_test_init
end

require 'test_bench'; TestBench.activate

require 'process_host/controls'
Controls = ProcessHost::Controls

require 'process_host/fixtures'
Fixtures = ProcessHost::Fixtures
