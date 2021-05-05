require "openapi3_parser"

module Openapi3Parser
  module Node
    class Schema < Node::Object
      
      attr_accessor :name, 
                    :name_from_path, 
                    :exposed, 
                    :consumed

      def service
        transparency_service.service
      end

      def transparency_service
        self.node_context.document
      end

      def get_name
        # return title if present, as it will be the most accurate name
        # else try to return the schema object name, if present
        return self.title if self.title
        return self.name if self.name
        # this could be set, e.g. if a schema is in a parameter, that is named
        return self.name_from_path if self.name_from_path

        if source_location = self.node_context.source_location and self.is_reference?
          # a little hacky way to get the name of the referenced schema
          if source_location&.pointer&.fragment.starts_with? "#/components/schemas/"
            path = source_location.pointer.fragment
            return path[21..path.length - 1]
          end
        end

        return nil
      end

      def properties
        # this return includes the property schematas
        self["properties"]
      end

      def property_schemas
        schemas = []
        properties.keys.each do |property_key|
          schema = properties[property_key]
          schema.name = property_key
          schemas << schema
        end
        return schemas
      end

      # def includes_personal_data?
      #   get_personal_data.size > 0
      # end

      def is_marked_as_personal?
        self.keys.include? "x-transparency"
      end


      def has_properties?
        properties.keys.size > 0
      end

      ## 
      # 
      # @return Node::PersonalDatum
      def get_personal_data
        # byebug
        return unless schema_name = get_name

        data = nil
        if is_marked_as_personal? and not self.is_component?
          data = Tira::PersonalDatum.new(schema_name, self["x-transparency"])
          data.exposed = self.exposed
          data.consumed = self.consumed
          data.add_schema(self)

          # .. and model has properties, parse all properties that are not marked as ignored
          if has_properties?
            # .. and model has properties, parse all properties that are not marked as ignored
            properties.keys.each do |property_key|
              property = properties[property_key]
              # save hash with key-name and property-node
              data.add_property({"#{property_key}" => property}) unless property.keys.include? "x-transparency-ignore"
                
            end
          end
        else

          if has_properties?
            # if the whole schema is not marked as personal, there can still be personal properties
            properties.keys.each do |property_key|
              if properties[property_key].keys.include? "x-transparency"
                # if data not yet defined, create it 
                data = Tira::PersonalDatum.new(schema_name, self["x-transparency"]) unless data
                data.add_schema(self)
                data.add_property({"#{property_key}" => properties[property_key]}) unless properties[property_key].keys.include? "x-transparency-ignore"
              end
            end
          end

        end

        return data


        # data = {}
        # if is_marked_as_personal? and not self.is_component?
        #   # if whole model is marked and not a component 
        #   # (if a component is not referenced it can be ignored, if it is it would occur twice) 
        #   if has_properties?
        #     # .. and model has properties, parse all properties that are not marked as ignored
        #     properties.keys.each do |property_key|
        #       if not properties[property_key].keys.include? "x-transparency-ignore"
        #         # save hash with key-name and property-node
        #         data[property_key] = properties[property_key]
        #       end
        #     end
        #   else
        #     # .. and model has NO properties, find different way to parse data name
        #     if schema_name = get_name
        #       # this only works, when a name is present, but this is a requirement anyways
        #       data[schema_name] = "TODO"
        #     end
        #   end
        # else
        #   if has_properties?
        #     # if the whole schema is not marked as personal, there can still be personal properties
        #     properties.keys.each do |property_key|
        #       if properties[property_key].keys.include? "x-transparency"
        #         data[property_key] = properties[property_key]
        #       end
        #     end
        #   end
        # end

        # return data
      end



      def is_component?
        # the context saves the location within the document
        self.node_context.location_summary.starts_with? "#/components/"
        
      end

      def is_reference?
        # if they are the same, schema is a component or defined in place
        (self.node_context.document_location != self.node_context.source_location)# and self.node_context.referenced_by != nil
      end

      def raw_data
        node_context.input
      end

      def raw_data_yaml
        if self.get_name
          # deep copy frozen hash
          raw = node_context.input.dup
          raw.delete("x-transparency") if raw["x-transparency"]
          raw["x-transparency"] = true
          raw["title"] = self.get_name
          # raw['x-transparency'] = {foo: "bar"}
          return raw.to_yaml
        end
      end

      def raw_data_json
        node_context.input.to_json
      end

      private
    


    end
  end
end