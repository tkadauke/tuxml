require 'test/unit/testcase'
require 'rexml/document'

module Test
  module Unit
    class TestCase
      def fault
        @_fault
      end
      
      def xml_element
        return if @method_name.to_s == "default_test"
        
        testcase = REXML::Element.new("testcase")
        testcase.add_attributes('classname' => self.class.name, 'name' => @method_name, 'time' => @_elapsed_time.to_s)
        if fault
          testcase.elements << fault.xml_element
        end
        testcase
      end

      def run_with_timing(result, &block)
        before_time = Time.now.to_f
        run_without_timing(result, &block)
      ensure
        after_time = Time.now.to_f
        @_elapsed_time = after_time - before_time
      end
      alias_method :run_without_timing, :run
      alias_method :run, :run_with_timing

    private
      # overridden from test/unit to store failures and errors inside the test_case
      def add_failure(message, all_locations=caller())
        @test_passed = false
        @_fault = Failure.new(name, filter_backtrace(all_locations), message)
        @_result.add_failure(@_fault)
      end

      def add_error(exception)
        @test_passed = false
        @_fault = Error.new(name, exception)
        @_result.add_error(@_fault)
      end
    end
  end
end

if defined?(ActiveSupport::TestCase)
  module ActiveSupport
    class TestCase
      alias_method :run_without_timing, :run
      alias_method :run, :run_with_timing
    end
  end
end
