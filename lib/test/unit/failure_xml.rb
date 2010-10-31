require 'test/unit/failure'
require 'rexml/document'

module Test
  module Unit
    class Failure
      def xml_element
        element = REXML::Element.new('failure')
        element.add_attributes('type' => 'Test::Unit::AssertionFailedError', 'message' => self.message)
        element.text = self.location.join("\n")
        element
      end
    end
  end
end
