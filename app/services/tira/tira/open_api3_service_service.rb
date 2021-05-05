require "openapi3_parser"

module Tira
  module OpenApiServices



    class OpenApi3ServiceService

      attr_accessor :service

      def initialize(service)
        @service = service
      end

      # def get_schemas_of_service
      #   document_service.
      # end

      def name
        service.name
      end
      
      def api_spec
        @service.api_specs.last
      end

      def utilizer
        document_service.utilizer
      end

      def non_eu?
        document_service.non_eu?
      end

      def country
        document_service.country
      end

      ## 
      # Returns a Transparency Service for the latest spec
      def document_service
        api_spec.transparency_service
      end

      def get_personal_data
        if api_spec
          return api_spec.transparency_service.get_personal_data
        end
      end
      



    end
  end
end