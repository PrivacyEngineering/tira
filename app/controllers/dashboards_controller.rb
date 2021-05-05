class DashboardsController < ApplicationController

    def overview
        

        @specs = transparency_service.get_all_current_specs
        # @personal_data = @specs.map { |as|
        #     as.get_personal_data if as
        # }
        @services_personal_data = transparency_service.get_personal_data_of_services

        

        @personal_data = transparency_service.get_all_personal_data_instances

        # @services_personal_data.keys.each do |service|
        #     @services_personal_data[service].each do |name, pd|
        #         # initialize if array for schema name is not yet
        #         @schemas[name] = [] if not @schemas[name]
        #         # add personal datum to array for schema
        #         @schemas[name] << {pd => service}
        #     end
        # end
    end

    def purposes
        # @purposes = transparency_service.get_all_purposes
        @purposes = transparency_service.get_purposes_with_info
    end

    def schemas
        
    end

    def network
        @services = Service.all
    end

    def transparency_service
        Tira::OpenApiServices::OpenApi3SystemService.new()
    end
end
