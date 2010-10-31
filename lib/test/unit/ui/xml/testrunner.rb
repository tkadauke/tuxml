require 'test/unit/ui/console/testrunner'

require 'rexml/document'

module Test
  module Unit
    module UI
      module Xml
        class TestRunner < Test::Unit::UI::Console::TestRunner
          def finished(elapsed_time)
            super(elapsed_time)
            
            xml_path = ENV["TUXML_OUTPUT_FILE"] || "tests.xml"

            nl
            File.open(xml_path,'w') {|file| file.write(to_xml) }
            output("XML output saved: #{xml_path}")
            nl
          end
          
        private
          def to_xml
            xml = REXML::Document.new
            xml.elements << @suite.xml_element
            xml.to_s
          end
        end
      end
    end
  end
end

if __FILE__ == $0
  Test::Unit::UI::Xml::TestRunner.start_command_line_test
end
