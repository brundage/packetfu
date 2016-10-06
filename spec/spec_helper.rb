require 'packetfu'
require 'support/fake_packets'


require 'coveralls'
Coveralls.wear!

puts "rspec #{RSpec::Core::Version::STRING}"
if RSpec::Core::Version::STRING[0] == '3'
  require 'rspec/its'
  RSpec.configure do |config|
    #config.raise_errors_for_deprecations!
    config.expect_with :rspec do |c|
      c.syntax = [:expect, :should]
    end
  end
end

PCAPS_LOCATION = File.join(File.dirname(__FILE__), 'pcaps')
