require "openapi3_parser"

module Tira
    ## 
    # This class represents a PersonalDatum
    # 
    class PersonalDatum

      attr_reader :name, 
                  :properties, 
                  :media_types, 
                  :x_tira, 
                  :schemas

      attr_accessor :exposed,
                    :consumed

      def initialize(name, x_tira, media_type=nil, schema=nil)
        @name = name

        @media_types = []
        @media_types = [media_type] if media_type
        
        @schemas = []
        @schemas = [schema] if schema

        @properties = []

        # the x-tira OpenAPI extensions that was encoded for the personal datum
        @x_tira = x_tira

        @transparency_properties = []
      end

      def get_transparency_properties
        [retention_time, purposes, utilizer] 
      end

      def service
        schema.service if schema
      end

      def schema
        @schemas.first if @schemas.size
      end

      def property_schemas
        schema.property_schemas
      end

      def special_category?
        return true
        if self.x_tira['special_category']
          return true
          # Tira::Property::SpecialCategory.new(self.x_tira['special_category'], self)
        else 
          return false
        end
      end


      def profiling_reason
        return "Reason X"
        self.x_tira['profiling']['reason']
      end

      def profiling?
        return true
        if self.x_tira['profiling']
          return true
          # Tira::Property::SpecialCategory.new(self.x_tira['profiling'], self)
        else 
          return false
        end
      end


      def add_properties(properties)
        properties.map{ |p|
          self.add_property(p)
        }
      end

      def add_property(property)
        self.properties << property
      end

      def add_schema(schema)
        # when multiple media_types are present, also multiple schemas exist
        return unless schema.class == Openapi3Parser::Node::Schema
        self.schemas << schema
      end

      def add_media_types
        
      end



      def retention_time
        if self.x_tira['retention-time']
          Tira::Property::RetentionTime.new(self.x_tira['retention-time'], self)
        else 
          return false
        end
      end

      def purposes
        if self.x_tira['purposes']
          if purposes_yappl = self.x_tira['purposes']['yappl']
            Tira::Property::Purposes.new(purposes_yappl, self)
          end
        end
      end



      def utilizer(withouth_service: false)
        us = []
        if self.x_tira['utilizer'] and self.exposed
          self.x_tira['utilizer'].each do |u|
            us << Tira::Property::Utilizer.new(u, self)

          end
        end
        if not withouth_service
          if service and service_utilizer = service.transparency_service.utilizer
            service_utilizer.each do |u|
              u.service_wide = true
            end
            us += service_utilizer
          end
        end
        return us
      end

      def utilizer_categories
        us = []
        if self.x_tira['utilizer_category'] and self.exposed
          self.x_tira['utilizer_category'].each do |u|
            us << Tira::Property::UtilizerCategory.new(u, self)

          end
        end
        return us
      end


      # #########################################

      def inspect
        %{#{self.class.name}: #{self.name}}
      end


      private


    end
  # end
end