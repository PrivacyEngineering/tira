module Openapi3Parser
  module Node
    class Parameter < Node::Object

      def is_marked_as_personal?
        self.keys.include? "x-transparency"
      end

      def get_schemas
        schemas = []
        if schema = self["schema"]
          schema.name_from_path = self.name
          schemas << schema
        # OpenAPI 3 allows EITHER schema or content
        # hence use elsif not own if clause
        elsif content = self["content"]
          schemas << content.keys.map{ |key|
            schema = get_schema_for_content(content[key])
            schema.name_from_path = self.name
            schema
          }
        end
        return schemas.flatten if schemas.length
      end

      def get_schema_for_content(content)
        content["schema"] if content["schema"]
      end

    end
  end
end