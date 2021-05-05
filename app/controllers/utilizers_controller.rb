class UtilizersController < ApplicationController

    def index
        @utilizers = transparency_service.get_all_utilizer(including_categories: true, including_services: false)

    end


    private
    def transparency_service
        Tira::OpenApiServices::OpenApi3SystemService.new()
    end
end
