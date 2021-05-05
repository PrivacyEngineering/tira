class SchemasController < ApplicationController


    def index
        @schemas = transparency_service.get_all_personal_data_instances
    end


    def get_raw_schema_by_name
        @name = get_name

        transparency_service = Tira::OpenApiServices::OpenApi3SystemService.new()
        if schema = transparency_service.get_schema_with_name_uniq[@name]
            # render :text => schema.raw_data_yaml.to_s
            respond_to do |format|
              # format.yaml {render :text => schema.raw_data_yaml, :content_type => 'text/yaml'}
              # format.json {render :text => schema.raw_data_json, :content_type => 'text/json'}
              format.html {render :plain => schema.raw_data_yaml, :content_type => 'text/plain'}
            end
        end

        return 404        
    end

    def get_purpose_ref_by_names
        @name = get_name

        purposes = transparency_service.get_purposes_with_info
        ps = purposes.select{|p| p.name == @name}
        if purpose = ps.first
            # check if purpose exists
            # yappl itself can be generated manually
            respond_to do |format|
              # format.yaml {render :text => schema.raw_data_yaml, :content_type => 'text/yaml'}
              # format.json {render :text => schema.raw_data_json, :content_type => 'text/json'}
              format.html {render :plain => generate_yappl(@name), :content_type => 'text/plain'}
            end

        end


    end


    private


    def get_name
        params[:name]
    end

    def transparency_service 
        Tira::OpenApiServices::OpenApi3SystemService.new()
    end


    def generate_yappl(purposes)
        y = 'yappl: \'{"id":123,"preference":[{"rule":{"purpose":{"permitted":'+purposes.to_s+',"excluded":[]},"utilizer": {"permitted": [],"excluded":[]},"transformation":[{"attribute":"temperature","tr_func": "minmax_hourly"}],"valid_from": "2017-10-09T00:00:00.000Z","exp_date": "0000-01-01T00:00:00.000Z"}}]}\''
        y.to_yaml
    end
end
