require "openapi3_parser"
module Tira
  module OpenApiServices
  # #########
  # TODO
  # cookie parsing
  # andere orte und zwar alle parsen
  # schema abstrahieren
  # title mandatory, falls keine properties erkennbar
  # 
  # header
  # cookie
  # responses
  # 
  # pfad
  # pfaditem
  # ...


  # PARAMETER OHNE SCHEMA


  # TODO NEU
  # Personal Data Klasse mit 
  #    - Name
  #    - Media Types
  #    - Properties
  #    - x-transparency dinger

  # Abhängigkeiten Parsen:
  # wenn der ganze pfad markiert ist, wenn pfad, ....
  # dann eine schöne lösung finden, dass zB das schema in einem pfad dann die eigenschaft des ganzen services zu third country auch erbt

  # wenn ein ganzer service markiert ist, muss das ja aber nicht für alles gelten, sondern nur für das was personal gemarkt ist

  # es muss aber ne möglichkeit geben zu sagen _alles_ hier ist personal




    ## 
    # This class is an extension of the Openapi3Parser::Document Class
    # It inherits all its functionality like validation and content parsing
    # Additionally it offers functionality to provide all the transparency relevant information 
    # 
    class OpenApi3DocumentService < AbstractOpenApiDocumentService

      attr_reader :reference_registry, :service

      def initialize (spec, service)
        super(Openapi3Parser::SourceInput::Raw.new(spec))
        @spec = spec
        @service = service
      end


      def valid?
        # return false if self.schemas.map{|schema| schema.get_name}.include? nil
        super()
      end

      def errors
        super()
      end

      def is_marked_as_personal?
        self.keys.include? "x-transparency"
      end

      def get_transparency_information
        if is_marked_as_personal?
          return self["x-transparency"]
        end
      end

      def utilizer
        us = []
        if trans_info = get_transparency_information 
          if trans_info['utilizer']
            utils = trans_info['utilizer']
            utils.each do |u|
              util = Tira::Property::Utilizer.new(u, self)
              util.service_wide = true
              us << util
            end
          end
        end
        return us
      end

      def non_eu?
        if trans_info = get_transparency_information 
          if trans_info['third_country']
            if trans_info['third_country']['non_eu_country']
              return trans_info['third_country']["non_eu_country"] == true
            end
          end
        end
      end

      def country
        if trans_info = get_transparency_information 
          if trans_info['third_country']
            if trans_info['third_country']['country']
              return trans_info['third_country']['country']
            end
          end
        end
      end

      ## 
      # Returns an Hashmap of PersonalData.name => Personal Data
      def consumed_personal_data
        return if not valid?

        personal_data = {}
        # personal_data = []
        schemas.each do |schema|
          personal_data_of_schema = schema.get_personal_data
          if personal_data_of_schema # and schema.get_name
            personal_data[schema.get_name] = personal_data_of_schema
            # personal_data << personal_data_of_schema
          end
        end

        return personal_data
      end


      ## 
      # Returns an Hashmap of PersonalData.name => Personal Data
      def exposed_personal_data
        return if not valid?
        personal_data = {}
        exposed_schemas.each do |schema|
          personal_data_of_schema = schema.get_personal_data
          if personal_data_of_schema # and schema.get_name
            personal_data[schema.get_name] = personal_data_of_schema
            # personal_data << personal_data_of_schema
          end
        end

        return personal_data

      end




      ##
      # Returns an array of Personal Data contained in this spec
      def get_personal_data(only_consumed: false)
        return if not valid?
        personal_data = []
        # schemas.map {|schema|
        #   schema.get_personal_data if schema.get_personal_data
        # }

        all_schemas = schemas
        if not only_consumed
          all_schemas += exposed_schemas
        end

        all_schemas.each do |schem|
          if pd = schem.get_personal_data
            # if not personal_data.map{|pd| pd.name}.include? pd.name
              # do not add, if schema occurs several times
              personal_data << pd
            # end
          end
        end


        return personal_data
      end


      def exposed_schemas
        schemas = paths.get_schemas(exposed: true)
        
      end

      def schemas
        # schemas can reside in components or in paths
        schemas = paths.get_schemas + parameters.map{|p| p.get_schemas }
        # schemas += components.get_schemas
        schemas.flatten
      end

      def parameters
        paths.get_parameters + components.get_parameters
      end





    end
  end
end