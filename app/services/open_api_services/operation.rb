module Openapi3Parser
  module Node
    class Operation < Node::Object

      def transparency_service
        self.node_context.document
      end

      def get_schemas_from_request_body
        # if self["requestBody"] and content = self["requestBody"]["content"]
        if content
          schemas = media_types.map{ |key|
            get_schema_for_content(content[key])
          }
        end
      end

      def request_body
        self["requestBody"]
      end

      def content
        request_body["content"] if request_body
      end

      def media_types
        content.keys if content
      end

      def get_parameters
        # get params of this path item
        params = []
        self.parameters.each do |p|
          params << p
        end
        return params
      end

      def get_schemas_from_responses
        schemas = []

        responses.keys.each do |key|
          schema = responses[key].get_schema
          if schema and schema.size and schema.first
            schema.first.exposed = true
            schemas << schema
          end
        end
        return schemas 
      end

      def get_responses
        responses = []
        self.responses.keys.each do |status|
          responses << self.responses[status]
        end
        return responses
      end

      private

      def get_schema_for_content(content)
        if content["schema"]
          s = content["schema"]
          s.consumed = true
          return s
        end
      end



    end
  end
end