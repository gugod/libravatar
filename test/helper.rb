require 'rubygems'
require 'minitest/autorun'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'libravatar'

class Test::Unit::TestCase
end
