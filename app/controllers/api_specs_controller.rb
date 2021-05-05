class ApiSpecsController < ApplicationController
    before_action :set_service
    before_action :set_api_spec, only: [:show_swagger]

    def index
        @api_specs = @service.api_specs.order(created_at: :desc)
    end

    def new
        @api_spec = ApiSpec.new(service: @service)
    end


    def show_swagger
        @personal_data = @api_spec.get_personal_data

        @spec = @api_spec.get_specification_file_content
        @spec_service = @api_spec.transparency_service
        # @spec_service.get_schemas_from_path

    end

    def create
        @api_spec = ApiSpec.new(api_spec_params)
        @api_spec.service = @service

        respond_to do |format|
            if @api_spec.save
                format.html { redirect_to service_api_specs_path(@service), notice: 'Spec successfully created.' }
            else
                format.html { render :new }
                format.json { render json: @api_spec.errors, status: :unprocessable_entity }
            end
        end
    end

    private

    def set_api_spec
      @api_spec = ApiSpec.find(params[:id])
    end

    def set_service
      @service = Service.find(params[:service_id])
    end

    def api_spec_params
      params.require(:api_spec).permit(:spec, :description, :commit_message, :branch, :author, :commit_url)
    end
end
