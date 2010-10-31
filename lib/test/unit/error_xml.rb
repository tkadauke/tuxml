require 'test/unit/error'
require 'rexml/document'

module Test
  module Unit
    class Error
      def xml_element
        element = REXML::Element.new('error')
        element.add_attributes('type' => exception.class.name, 'message' => exception.message)
        element.text = exception.backtrace.join("\n")
        element
      end
    end
  end
end
