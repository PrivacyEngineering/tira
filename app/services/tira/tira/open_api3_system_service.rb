require "openapi3_parser"

module Tira
  module OpenApiServices



    class OpenApi3SystemService


      def initialize 

      end


      def services
        get_all_data_processing_services
      end



      def get_purposes_with_info
        # get_personal_data_of_services.keys.each do |service|
        #   personal_data = get_personal_data_of_services[service]
        # end
        purposes = {}
        services.each do |service|
          service_service = service.transparency_service
          service_service.get_personal_data.each do |pd|
            if pd.purposes
              pd.purposes.get_permitted_purposes.each do |purpose|
                # if a purpose with this name is not already present
                if not purposes[purpose.name]
                  purposes[purpose.name] = purpose
                end
                purposes[purpose.name].add_personal_datum(pd)
                purposes[purpose.name].add_service(service)
              end
            end
          end
        end
        # until here it is a hash, vor checking purposes by their names
        # it is sufficient to return them as an array though
        return purposes.values
      end


      def get_all_utilizer(including_categories: false, including_services: false)
        # get_personal_data_of_services.keys.each do |service|
        #   personal_data = get_personal_data_of_services[service]
        # end

        utilizers = {}
        services_personal_data = get_personal_data_of_services(only_exposed: true)


        services_personal_data.each do |service, personal_data|
          service_service = service.transparency_service
          utilizers_of_service = []
          if service_service.utilizer
            utilizers_of_service += service_service.utilizer
          end
          personal_data.each do |pd_name, personal_datum|
            if personal_datum.utilizer
              # ###########################
              utils = personal_datum.utilizer
              if including_categories
                utils += personal_datum.utilizer_categories
              end
              # utils += utilizers_of_service  
              # ###########################
              utils.each do |utilizer|
                # if a purpose with this name is not already present
                if not utilizers.keys.map{|k| k.name}.include? utilizer.name
                  utilizers[utilizer] = []
                end
                utilizers.each do |u, val|
                  if u.name == utilizer.name
                    utilizers[u] << personal_datum
                  end
                end
              end
            end
          end
          ####
          # das ist quasi obsolet, weil im PD die Utilizer des Services mitgeholt werden
          ####
          # if including_services
          #   service.transparency_service.utilizer.each do |utilizer|
          #     if not utilizers.keys.map{|k| k.name}.include? utilizer.name
          #       utilizers[utilizer] = []
          #     end
          #     personal_data.each do |pd_name, personal_datum|
          #       utilizers.each do |u, val|
          #         if u.name == utilizer.name
          #           utilizers[u] << personal_datum
          #         end
          #       end
          #     end
          #   end
          # end
        end
        return utilizers

        # services.each do |service|
        #   service_service = service.transparency_service
        #   utilizers_of_service = []
        #   if service_service.utilizer
        #     utilizers_of_service += service_service.utilizer
        #   end
        #   service_service.get_personal_data.each do |pd|
        #     if pd.utilizer
        #       # ###########################
        #       utils = pd.utilizer
        #       utils += utilizers_of_service  
        #       # ###########################
        #       utils.each do |utilizer|
        #         # if a purpose with this name is not already present
        #         if not utilizers[utilizer.name]
        #           utilizers[utilizer.name] = []
        #         end
        #         utilizers[utilizer.name] << pd
        #       end
        #     end
        #   end
        # end
      end


      # ###########################################
      # Helpers
      # ###########################################

      def service_transparency_services
        services.map{|service|
          service.transparency_service
        }
      end

      ##
      # gets the latest spec for all services of the whole system
      def get_all_current_specs
        get_all_data_processing_services.map {|s|
          # and get the most current 
          s.api_specs.last
        }
      end

      def get_all_data_processing_services
        Service.where(ignore: [nil, false]).select{ |s|
          # only get services, that have specs
          s.api_specs.last
        }
      end


      # ###########################################
      # ###########################################
      # ###########################################
      # ###########################################
      # ###########################################

      def get_all_personal_data_instances
        # returns all personal Data instances that appear for a schema
        # i.e. if Stepcount appears in two services, both stepcount instances will appear hear
        schemas = {}

        pd_of_services = get_personal_data_of_services(only_consumed: true)

        pd_of_services.keys.each do |service|
            pd_of_services[service].each do |name, pd|
                # initialize if array for schema name is not yet
                schemas[name] = {} if not schemas[name]
                schemas[name]["consumed"] = [] if not schemas[name]["consumed"]
                # add personal datum to array for schema
                schemas[name]["consumed"] << {pd => service}
            end
        end
        pd_of_services = get_personal_data_of_services(only_exposed: true)

        pd_of_services.keys.each do |service|
            pd_of_services[service].each do |name, pd|
                # initialize if array for schema name is not yet
                schemas[name] = {} if not schemas[name]
                schemas[name]["exposed"] = [] if not schemas[name]["exposed"]
                # add personal datum to array for schema
                schemas[name]["exposed"] << {pd => service}
            end
        end
        return schemas
      end

      def get_all_purpose_names
        get_personal_data.map{|pd| 
          pd.purposes.get_permitted_purposes if pd.purposes and pd.purposes.get_permitted_purposes
        }.flatten
      end

      def get_all_schemas_names
        get_all_current_specs.map{ |s| 
          s.transparency_service.schemas
        }.flatten.map{ |s| 
          s.get_name
        }.uniq
      end

      def get_all_schemas_with_names
        get_all_current_specs.map{|s| 
          s.transparency_service.schemas.map {|h| 
            {h.get_name => h}
          }
        }.flatten  
      end

      def get_schema_with_name_uniq
        schemas = {}
        get_all_schemas_with_names.reverse_each do |schema_entry|

          schemas[schema_entry.first.first] = schema_entry.first.second
        end
        return schemas
      end

      def get_personal_data_of_services(only_exposed: false, only_consumed: false)
        # hash of services with array of their personal data
        services_personal_data = {}
        
        get_all_current_specs.map { |spec|
            if spec and spec.service
              # TODO achtung, wenn hier 2 mal das gleiche Datum jeweils exposed und consumed ist, kommts nur einmal vor.
              # macht auch sinn soweit
              if only_consumed
                pd = spec.transparency_service.consumed_personal_data
              elsif only_exposed
                pd = spec.transparency_service.exposed_personal_data
              else
                pd = spec.transparency_service.consumed_personal_data.merge(spec.transparency_service.exposed_personal_data)
              end
              
              services_personal_data[spec.service] = pd
            end
        }
        return services_personal_data
      end



      def get_personal_data
        # array of personal data instances
        personal_data = []
        get_all_current_specs.each do  |spec|
            if spec and spec.service and spec.transparency_service.get_personal_data
                personal_data << spec.transparency_service.get_personal_data
            end
        end
        return personal_data.flatten
      end



    end
  end
end