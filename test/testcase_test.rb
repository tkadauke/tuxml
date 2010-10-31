require "test/unit"
require File.dirname(__FILE__) + '/../lib/test/unit/testcase_xml'
require File.dirname(__FILE__) + '/../lib/test/unit/failure_xml'
require File.dirname(__FILE__) + '/../lib/test/unit/error_xml'

class TestCaseTest < Test::Unit::TestCase
  def test_should_generate_xml_for_passing_test
    klass = Class.new(Test::Unit::TestCase) do
      def test_succeeds
        assert true
      end
    end
    
    testcase = klass.new('test_succeeds')
    result = Test::Unit::TestResult.new
    testcase.run(result) {}

    doc = REXML::Document.new(testcase.xml_element.to_s)

    assert_equal "testcase", doc.elements.first.name
    assert_equal "test_succeeds", doc.elements.first.attributes['name']
    assert doc.elements.first.attributes['time'].to_f > 0.0
    assert doc.elements.first.attributes.has_key?('classname')
  end
  
  def test_should_generate_xml_for_failing_test
    klass = Class.new(Test::Unit::TestCase) do
      def test_fails
        assert false
      end
    end
    
    testcase = klass.new('test_fails')
    result = Test::Unit::TestResult.new
    testcase.run(result) {}
    
    doc = REXML::Document.new(testcase.xml_element.to_s)
    
    assert_equal "failure", doc.elements.first.first.name
    assert_equal 'Test::Unit::AssertionFailedError', doc.elements.first.first.attributes['type']
    assert_equal "<false> is not true.", doc.elements.first.first.attributes['message']
  end
  
  def test_should_generate_xml_for_test_with_error
    klass = Class.new(Test::Unit::TestCase) do
      def test_fails
        raise 'boo'
      end
    end
    
    testcase = klass.new('test_fails')
    result = Test::Unit::TestResult.new
    testcase.run(result) {}
    
    doc = REXML::Document.new(testcase.xml_element.to_s)
    
    assert_equal "error", doc.elements.first.first.name
    assert_equal 'RuntimeError', doc.elements.first.first.attributes['type']
    assert_equal "boo", doc.elements.first.first.attributes['message']
  end
  
  def test_should_not_generate_xml_for_default_test
    klass = Class.new(Test::Unit::TestCase)
    
    testcase = klass.new('default_test')
    result = Test::Unit::TestResult.new
    testcase.run(result) {}
    
    assert_nil testcase.xml_element
  end
end
