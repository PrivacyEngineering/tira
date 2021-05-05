module Openapi3Parser
  module Node
    class Response < Node::Object

      def get_schema
        self.content.keys.map{ |key|
          get_schema_for_content(self.content[key])
        }
      end

      def get_headers
        
      end

      private

      def get_schema_for_content(content)
        content["schema"] if content["schema"]
      end
    

    end
  end
end