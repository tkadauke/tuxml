require "test/unit"
require File.dirname(__FILE__) + '/../lib/test/unit/testcase_xml'
require File.dirname(__FILE__) + '/../lib/test/unit/testsuite_xml'
require File.dirname(__FILE__) + '/../lib/test/unit/failure_xml'
require File.dirname(__FILE__) + '/../lib/test/unit/error_xml'

class TestSuiteTest < Test::Unit::TestCase
  def test_should_generate_xml_for_testsuite_with_testcase_children
    klass = Class.new(Test::Unit::TestCase) do
      def test_succeeds
        assert true
      end
    end
    
    testcase = klass.new('test_succeeds')
    result = Test::Unit::TestResult.new
    testsuite = Test::Unit::TestSuite.new("SomeTestSuite")
    testsuite << testcase
    testsuite.run(result) {}
    
    doc = REXML::Document.new(testsuite.xml_element.to_s)

    assert_equal "testsuite", doc.elements.first.name
    assert_equal "SomeTestSuite", doc.elements.first.attributes['name']
    assert_equal "0", doc.elements.first.attributes['failures']
    assert_equal "0", doc.elements.first.attributes['errors']
    assert_equal "1", doc.elements.first.attributes['tests']
    assert doc.elements.first.attributes['time'].to_f > 0.0
    assert doc.elements.first.attributes.has_key?('timestamp')
  end

  def test_should_count_failing_tests_for_testsuite_with_testcase_children
    klass = Class.new(Test::Unit::TestCase) do
      def test_fails
        assert false
      end
    end
    
    testcase = klass.new('test_fails')
    result = Test::Unit::TestResult.new
    testsuite = Test::Unit::TestSuite.new("SomeTestSuite")
    testsuite << testcase
    testsuite.run(result) {}
    
    doc = REXML::Document.new(testsuite.xml_element.to_s)

    assert_equal "1", doc.elements.first.attributes['failures']
  end

  def test_should_count_error_tests_for_testsuite_with_testcase_children
    klass = Class.new(Test::Unit::TestCase) do
      def test_fails
        raise 'boo'
      end
    end
    
    testcase = klass.new('test_fails')
    result = Test::Unit::TestResult.new
    testsuite = Test::Unit::TestSuite.new("SomeTestSuite")
    testsuite << testcase
    testsuite.run(result) {}
    
    doc = REXML::Document.new(testsuite.xml_element.to_s)

    assert_equal "1", doc.elements.first.attributes['errors']
  end

  def test_should_generate_xml_for_testsuite_with_testsuite_children
    klass = Class.new(Test::Unit::TestCase) do
      def test_succeeds
        assert true
      end
    end
    
    result = Test::Unit::TestResult.new
    testsuite = Test::Unit::TestSuite.new("SomeTestSuite")
    subsuite = Test::Unit::TestSuite.new("SubTestSuite")
    subsuite << klass.new('test_succeeds')
    testsuite << subsuite
    
    testsuite.run(result) {}
    
    doc = REXML::Document.new(testsuite.xml_element.to_s)

    assert_equal "testsuites", doc.elements.first.name
  end
  
  def test_should_not_generate_xml_for_empty_testsuite
    result = Test::Unit::TestResult.new
    testsuite = Test::Unit::TestSuite.new("SomeTestSuite")
    
    testsuite.run(result) {}
    
    assert_nil testsuite.xml_element
  end
end
