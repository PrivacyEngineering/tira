module Openapi3Parser
  module Node
    class Components < Node::Object

      def get_schemas
        schemas = []
        self.schemas.keys.each do |key|
            schema = self.schemas[key]
            # when parsed from compoenents, we do have a name, so save in schema
            schema.name = key
            schemas << schema
        end
        return schemas
      end

      def get_parameters
        params = []
        self.parameters.keys.each do |key|
          params << self.parameters[key]
        end
        return params.flatten
      end


    end
  end
end