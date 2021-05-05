module Openapi3Parser
  module Node
    class PathItem < Node::Object
      HTTP_METHODS = %w{post get put delete head patch}
      REQEUST_BODY_METHODS = %w{put post patch}

      def transparency_service
        self.node_context.document
      end


      def get_schemas(exposed=false)
        schemas = []

        if not exposed
          # get schemas of all methods, where bodies are allowed
          get_operations_for_methods(REQEUST_BODY_METHODS).each do |operation|
            schemas << operation.get_schemas_from_request_body if operation.get_schemas_from_request_body
          end
        else
          get_operations_for_methods(HTTP_METHODS).each do |operation|
            schemas << operation.get_schemas_from_responses if operation.get_schemas_from_responses
          end
        end

        return schemas
        
      end


      def get_parameters
        # get params of this path item
        params = []
        self.parameters.each do |p|
          params << p
        end
        
        # get params of all methods
        get_operations_for_methods(HTTP_METHODS).each do |operation|
          params << operation.get_parameters
        end

        return params.flatten
      end


      def get_operations_for_methods(methods)
        operations = []
        methods.each do |method|
          operations << get_operation_for_method(method) if get_operation_for_method(method)
        end
        return operations
      end

      def get_operation_for_method(method)
        self[method]
      end


    end
  end
end