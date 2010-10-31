require 'test/unit'

Test::Unit::AutoRunner::RUNNERS[:xml] = proc do |r|
  require File.dirname(__FILE__) + '/test/unit/ui/xml/testrunner'
  require File.dirname(__FILE__) + '/test/unit/testsuite_xml'
  require File.dirname(__FILE__) + '/test/unit/testcase_xml'
  require File.dirname(__FILE__) + '/test/unit/error_xml'
  require File.dirname(__FILE__) + '/test/unit/failure_xml'
  Test::Unit::UI::Xml::TestRunner
end
