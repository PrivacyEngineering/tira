class ApiSpec < ApplicationRecord
    belongs_to :service

    has_one_attached :open_api_specification

    # validates :spec, presence: true


    def get_personal_data
        # @spec_service.get_schemas_from_path
        transparency_service.consumed_personal_data
    end

    def transparency_service
        Tira::OpenApiServices::OpenApi3DocumentService.new(self.get_specification_file_content, self.service) if self.get_specification_file_content and self.service
    end

    def get_specification_file_content
        if self.open_api_specification
            file = File.open(ActiveStorage::Blob.service.send(:path_for, self.open_api_specification.key))
            data = File.read(file)
            case self.open_api_specification.content_type
                when "application/x-yaml"
                    return YAML.load(data).to_json
                when "application/json"
                    # ##############################
                    # TODO Validate JSON
                    # 
                    # (probably at another place (on upload), but has to be done before here)
                    # ##############################
                    
                    # json data can be utilized as is
                    return data
            else
                return nil
            end
        end
        return nil
    end

end
