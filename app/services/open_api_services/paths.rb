module Openapi3Parser
  module Node
    class Paths < Node::Map
      
      def transparency_service
        self.node_context.document
      end

      def get_schemas(exposed=false)
        schemas = []

        self.get_path_items.each do |path_item|
          schemas << path_item.get_schemas(exposed)
        end
        
        return schemas.flatten
      end

      def get_parameters
        get_path_items.map{|p| p.get_parameters}.flatten
      end



      def get_path_items
        path_items = []
        self.keys.each do |path_key|
          path_items << self[path_key]
        end
        return path_items
      end

    end
  end
end